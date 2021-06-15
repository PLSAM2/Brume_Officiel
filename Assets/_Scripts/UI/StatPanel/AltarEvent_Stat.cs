using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class AltarEvent_Stat : MonoBehaviour
{
    public GameObject red, blue;

    public void SetInMyTeam(bool _value)
    {
        blue.SetActive(_value == true);
        red.SetActive(_value == false);
    }
}
