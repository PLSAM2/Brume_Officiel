using UnityEngine;
using System.Threading;
using System.Collections;
using System.Collections.Generic;

public class FOWSystem : MonoBehaviour
{
    private static FOWSystem _instance;
    public static FOWSystem Instance { get { return _instance; } }

    public Color outBrumeColor = new Color(0.05f, 0.05f, 0.05f, 1f);
    public Color inBrumeColor = new Color(0.05f, 0.05f, 0.05f, 1f);

    [HideInInspector]
    public Color currentFogColor = new Color(0.05f, 0.05f, 0.05f, 1f);

    public Material mistMatPlane;
    public Material fogMat;

    public int worldSize = 256;
    public int textureSize = 128;

    public float blendFactor = 0;

    public RenderTexture myTexture;
    public float opacity;

    AnimationCurve curveOpacity;

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }

        mistMatPlane.SetFloat("_Opacity", 0);

        curveOpacity = new AnimationCurve();
        curveOpacity.AddKey(new Keyframe(0.2f, 1));
        curveOpacity.AddKey(new Keyframe(0.33f, 0.5f));
    }

    float opacityValue = 0;
    private void Update()
    {
        LocalPlayer localPlayer = GameFactory.GetActualPlayerFollow();

        if (localPlayer != null)
        {
            if (localPlayer.myPlayerModule.isInBrume)
            {
                currentFogColor = Color.Lerp(currentFogColor, inBrumeColor, Time.deltaTime * 5);
                opacityValue = Mathf.Lerp(opacityValue, curveOpacity.Evaluate(localPlayer.myPlayerModule.inBrumeValue), Time.deltaTime * 5);
            }
            else
            {
                currentFogColor = Color.Lerp(currentFogColor, outBrumeColor, Time.deltaTime * 5);
                opacityValue = Mathf.Lerp(opacityValue, 0, Time.deltaTime * 5);
            }

            mistMatPlane.SetFloat("_Opacity", opacityValue);
        }
    }

    private void OnDisable()
    {
        mistMatPlane.SetFloat("_Opacity", 0);
        fogMat.SetColor("_Unexplored", Color.black);
    }
}
