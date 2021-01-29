using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlendTest : MonoBehaviour
{
    public RenderTexture entre;

    private Texture2D sourceRender;

    public Material shader;

    private void Awake()
    {
        sourceRender = new Texture2D(entre.width, entre.height);
    }

    private void Update()
    {
        Color[] sourcePixels = toTexture2D(entre).GetPixels();
        Color[] destinationPixels = sourceRender.GetPixels();

        for (int i = 0; i < sourcePixels.Length; i++)
        {
            destinationPixels[i] = new Color(
                (sourcePixels[i].r * destinationPixels[i].r) / 1.0f,
                (sourcePixels[i].g * destinationPixels[i].g) / 1.0f,
                (sourcePixels[i].b * destinationPixels[i].b) / 1.0f,
                (sourcePixels[i].a * destinationPixels[i].a) / 1.0f
            );
        }

        sourceRender.SetPixels(destinationPixels);
        sourceRender.Apply();


        shader.SetTexture("_MainTex", sourceRender);
    }

    Texture2D toTexture2D(RenderTexture rTex)
    {
        Texture2D tex = new Texture2D(entre.width, entre.height, TextureFormat.RGB24, false);
        RenderTexture.active = rTex;
        tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
        tex.Apply();
        return tex;
    }
}
