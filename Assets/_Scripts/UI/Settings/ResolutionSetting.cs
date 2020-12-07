using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResolutionSetting : MonoBehaviour
{
    public GameObject selected1080;
    public GameObject selected720;

    private void Start()
    {
        if(Screen.width == 1920 && Screen.height == 1080)
        {
            ChangeResolution(1920, 1080);
        }

        if(Screen.width == 1280 && Screen.height == 720)
        {
            ChangeResolution(1280, 720);
        }
    }

    public void ChangeResolution(int w, int h)
    {
        Screen.SetResolution(w, h, true);

        selected1080.SetActive(h == 1080);
        selected720.SetActive(h == 720);
    }
}
