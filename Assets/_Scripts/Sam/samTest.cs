using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    private static samTest _instance;
    public static samTest Instance { get { return _instance; } }

    public RenderTexture myText1;

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
