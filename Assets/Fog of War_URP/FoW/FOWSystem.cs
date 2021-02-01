using UnityEngine;
using System.Threading;
using System.Collections;
using System.Collections.Generic;

public class FOWSystem : MonoBehaviour
{
    private static FOWSystem _instance;
    public static FOWSystem Instance { get { return _instance; } }


    public Color unexploredColor = new Color(0.05f, 0.05f, 0.05f, 1f);

    public int worldSize = 256;
    public int textureSize = 128;

    public float blendFactor = 0;

    public RenderTexture myTexture;

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
    }
}
