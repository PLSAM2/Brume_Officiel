using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResolutionElement : MonoBehaviour
{
    [SerializeField] int w;
    [SerializeField] int h;

    [SerializeField] ResolutionSetting myResoSetting;

    public void ChangeResolution()
    {
        myResoSetting.ChangeResolution(w, h);
    }
}
