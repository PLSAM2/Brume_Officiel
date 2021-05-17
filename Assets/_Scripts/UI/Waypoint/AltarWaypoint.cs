using DG.Tweening;
using PixelPlay.OffScreenIndicator;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class AltarWaypoint : Waypoint
{
    public List<GameObject> lockObj = new List<GameObject>();

    public void SetLockStatut(bool _value)
    {
        foreach(GameObject obj in lockObj)
        {
            obj.SetActive(_value);
        }
    }
}
