using UnityEngine;

[ExecuteInEditMode]
public class BlurFilter : MonoBehaviour
{
    [SerializeField, Range(0, 30)]
    int _iteration = 4;

    public Material _material;
    public Material _material1;

    public RenderTexture myTexture;

    void Update()
    {
        RenderTexture rt1 = RenderTexture.GetTemporary(myTexture.width / 2, myTexture.height / 2);
        RenderTexture rt2 = RenderTexture.GetTemporary(myTexture.width / 2, myTexture.height / 2);

        Graphics.Blit(myTexture, rt1, _material, 0);

        for (var i = 0; i < _iteration; i++)
        {
            Graphics.Blit(rt1, rt2, _material, 1);
            Graphics.Blit(rt2, rt1, _material, 2);
        }

        _material1.SetTexture("_FogTex0", rt1);

        //RenderTexture.ReleaseTemporary(rt1);
        RenderTexture.ReleaseTemporary(rt2);

    }
}