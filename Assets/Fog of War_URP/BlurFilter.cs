using UnityEngine;

[ExecuteInEditMode]
public class BlurFilter : MonoBehaviour
{
    [SerializeField, Range(0, 30)]
    int _iteration = 4;

    public Material _material;
    public Material _material1;

    public RenderTexture myTexture;

    RenderTexture rt1;
    RenderTexture rt2;
    //RenderTexture save;

    private void Start()
    {
        rt1 = RenderTexture.GetTemporary(myTexture.width / 2, myTexture.height / 2);
        rt2 = RenderTexture.GetTemporary(myTexture.width / 2, myTexture.height / 2);
        //save = RenderTexture.GetTemporary(myTexture.width, myTexture.height);
    }

    void Update()
    {
        Graphics.Blit(myTexture, rt1, _material, 0);

        for (var i = 0; i < _iteration; i++)
        {
            Graphics.Blit(rt1, rt2, _material, 1);
            Graphics.Blit(rt2, rt1, _material, 2);
        }

        _material1.SetTexture("_FogTex0", rt1);

        //Graphics.Blit(rt1, save);

        RenderTexture.ReleaseTemporary(rt1);
        RenderTexture.ReleaseTemporary(rt2);
    }
}