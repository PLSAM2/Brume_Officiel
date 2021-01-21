using UnityEngine.SceneManagement;

namespace UnityEngine.Rendering.Universal
{
    public class FogPass : ScriptableRenderPass
    {
        public FilterMode filterMode { get; set; }
        public FogFeature.Settings settings;

        RenderTargetIdentifier source;
        RenderTargetIdentifier destination;
        int temporaryRTId = Shader.PropertyToID("_TempRT");

        int sourceId;
        int destinationId;
        bool isSourceAndDestinationSameTarget;

        string m_ProfilerTag;


        //fog
        FOWSystem mFog;
        Camera mCam;
        Matrix4x4 mInverseMVP;

        public FogPass(string tag)
        {
            m_ProfilerTag = tag;
        }

        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            RenderTextureDescriptor blitTargetDescriptor = renderingData.cameraData.cameraTargetDescriptor;
            blitTargetDescriptor.depthBufferBits = 0;

            isSourceAndDestinationSameTarget = settings.sourceType == settings.destinationType &&
                (settings.sourceType == BufferType.CameraColor || settings.sourceTextureId == settings.destinationTextureId);

            var renderer = renderingData.cameraData.renderer;

            if (settings.sourceType == BufferType.CameraColor)
            {
                sourceId = -1;
                source = renderer.cameraColorTarget;
            }
            else
            {
                sourceId = Shader.PropertyToID(settings.sourceTextureId);
                cmd.GetTemporaryRT(sourceId, blitTargetDescriptor, filterMode);
                source = new RenderTargetIdentifier(sourceId);
            }

            if (isSourceAndDestinationSameTarget)
            {
                destinationId = temporaryRTId;
                cmd.GetTemporaryRT(destinationId, blitTargetDescriptor, filterMode);
                destination = new RenderTargetIdentifier(destinationId);
            }
            else if (settings.destinationType == BufferType.CameraColor)
            {
                destinationId = -1;
                destination = renderer.cameraColorTarget;
            }
            else
            {
                destinationId = Shader.PropertyToID(settings.destinationTextureId);
                cmd.GetTemporaryRT(destinationId, blitTargetDescriptor, filterMode);
                destination = new RenderTargetIdentifier(destinationId);
            }

            //setup
            if(mFog == null)
            {
                mFog = FOWSystem.instance;
            }

            mCam = Camera.main;
            //mCam.depthTextureMode = DepthTextureMode.Depth;
        }

        /// <inheritdoc/>
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            //fog
            SendShaderValue();

            CommandBuffer cmd = CommandBufferPool.Get(m_ProfilerTag);

            // Can't read and write to same color target, create a temp render target to blit. 
            if (isSourceAndDestinationSameTarget)
            {
                Blit(cmd, source, destination, settings.blitMaterial, settings.blitMaterialPassIndex);
                Blit(cmd, destination, source);
            }
            else
            {
                Blit(cmd, source, destination, settings.blitMaterial, settings.blitMaterialPassIndex);
            }

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        /// <inheritdoc/>
        public override void FrameCleanup(CommandBuffer cmd)
        {
            if (destinationId != -1)
                cmd.ReleaseTemporaryRT(destinationId);

            if (source == destination && sourceId != -1)
                cmd.ReleaseTemporaryRT(sourceId);
        }

        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            mFog.unexploredColor = Color.black;
        }

        void SendShaderValue()
        {
            if (mFog == null || SceneManager.GetActiveScene().name != "NewGame")
            {
                return;
            }

            // Calculate the inverse modelview-projection matrix to convert screen coordinates to world coordinates
            mInverseMVP = (mCam.projectionMatrix * mCam.worldToCameraMatrix).inverse;

            float invScale = 1f / mFog.worldSize;
            Transform t = mFog.transform;
            float x = t.position.x - mFog.worldSize * 0.5f;
            float y = t.position.z - mFog.worldSize * 0.5f;

            Vector4 camPos = mCam.transform.position;

            if (QualitySettings.antiAliasing > 0)
            {
                RuntimePlatform pl = Application.platform;

                if (pl == RuntimePlatform.WindowsEditor ||
                    pl == RuntimePlatform.WindowsPlayer ||
                    pl == RuntimePlatform.WebGLPlayer)
                {
                    camPos.w = 1f;
                }
            }

            Vector4 p = new Vector4(-x * invScale, -y * invScale, invScale, mFog.blendFactor);
            settings.blitMaterial.SetColor("_Unexplored", mFog.unexploredColor);
            //settings.blitMaterial.SetTexture("_FogTex0", mFog.texture0);
            //settings.blitMaterial.SetTexture("_FogTex1", mFog.texture1);

            settings.blitMaterial.SetTexture("_FogTex0", samTest.Instance.myText1);
            //settings.blitMaterial.SetTexture("_FogTex1", samTest.Instance.myText1);

            settings.blitMaterial.SetMatrix("_InverseMVP", mInverseMVP);
            settings.blitMaterial.SetVector("_CamPos", camPos);
            settings.blitMaterial.SetVector("_Params", p);
        }
    }
}
