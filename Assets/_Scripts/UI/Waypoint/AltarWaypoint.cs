using DG.Tweening;
using PixelPlay.OffScreenIndicator;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class AltarWaypoint : Waypoint
{
    [SerializeField] private TextMeshProUGUI timerALtarIn;
    [SerializeField] private TextMeshProUGUI timerALtarOut;

    [SerializeField] private Animator aninTimerALtarIn;
    [SerializeField] private Animator aninTimerALtarOut;

    [SerializeField] private Color lockColor;

    public void SetTimer(int _value)
    {
        if (0 == _value)
        {
            timerALtarIn.text = "";
            timerALtarOut.text = "";
            return;
        }

        if (timerALtarIn.text != _value.ToString())
        {
            timerALtarIn.text = _value.ToString();
            timerALtarOut.text = _value.ToString();

            //anim
            if(_value <= 5)
            {
                aninTimerALtarIn.SetTrigger("DoColor");
                aninTimerALtarOut.SetTrigger("DoColor");
            }
            else
            {
                aninTimerALtarIn.SetTrigger("DoScale");
                aninTimerALtarOut.SetTrigger("DoScale");
            }
        }
    }

    public void SetLock()
    {
        SetImageColor(lockColor);
    }

    public void SetUnLock()
    {
        SetImageColor(Color.white);
        SetUnderText("");
    }
}
