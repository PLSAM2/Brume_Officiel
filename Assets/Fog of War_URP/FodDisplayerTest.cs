using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FodDisplayerTest : MonoBehaviour
{
    //fog
    FOWSystem mFog;
    Camera mCam;
    Matrix4x4 mInverseMVP;

    public Material mat;

    private void Start()
    {
        //setup
        if (mFog == null)
        {
            mFog = FOWSystem.instance;
        }

        mCam = Camera.main;
        mCam.depthTextureMode = DepthTextureMode.Depth;
    }

    // Update is called once per frame
    void Update()
    {
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
        mat.SetColor("_Unexplored", mFog.unexploredColor);
        mat.SetTexture("_FogTex0", mFog.texture0);
        mat.SetTexture("_FogTex1", mFog.texture1);
        mat.SetMatrix("_InverseMVP", mInverseMVP);
        mat.SetVector("_CamPos", camPos);
        mat.SetVector("_Params", p);
    }
}
