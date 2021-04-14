namespace UnityEngine.Rendering.Universal
{
    public enum BufferType
    {
        CameraColor,
        Custom
    }

    public class FogFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class Settings
        {
            public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingOpaques;

            public Material blitMaterial;
            public Material _material;
            public int blitMaterialPassIndex = -1;
            public string sourceTextureId = "_SourceTexture";

            [SerializeField, Range(0, 8)]
            public int _iteration = 4;
        }

        public Settings settings = new Settings();
        FogPass blitPass;

        public override void Create()
        {
            //settings.blitMaterial.hideFlags = HideFlags.HideAndDontSave;
            blitPass = new FogPass(name);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (settings.blitMaterial == null)
            {
                Debug.LogWarningFormat("Missing Blit Material. {0} blit pass will not execute. Check for missing reference in the assigned renderer.", GetType().Name);
                return;
            }

            blitPass.renderPassEvent = settings.renderPassEvent;
            blitPass.settings = settings;
            renderer.EnqueuePass(blitPass);
        }
    }
}