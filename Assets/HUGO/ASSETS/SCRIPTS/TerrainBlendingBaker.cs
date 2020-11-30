using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class TerrainBlendingBaker : MonoBehaviour
{
    public Shader depthShader;
    public RenderTexture depthTexture;
    private Camera cam;

    private void UpdateBakingCamera()
    {
        if(cam == null)
        {
            cam = GetComponent<Camera>();
        }

        Shader.SetGlobalFloat("TB_SCALE", GetComponent<Camera>().orthographicSize * 2);
        Shader.SetGlobalFloat("TB_OFFSET_X", cam.transform.position.x - cam.orthographicSize);
        Shader.SetGlobalFloat("TB_OFFSET_Z", cam.transform.position.z - cam.orthographicSize);
        Shader.SetGlobalFloat("TB_OFFSET_Y", cam.transform.position.y - cam.farClipPlane);
        Shader.SetGlobalFloat("TB_FARCLIP", cam.farClipPlane);
    }

    [ContextMenu("Bake Depth Texture")]
    public void BakeTerrainDepth()
    {
        UpdateBakingCamera();

        if (depthShader != null && depthTexture != null)
        {
            cam.SetReplacementShader(depthShader, "RenderType");
            cam.targetTexture = depthTexture;
            Shader.SetGlobalTexture("TB_DEPTH", depthTexture);
        }
        else
        {
            Debug.Log("You need to assign the depth shader and depth texture in the inspector");
        }
    }
}
