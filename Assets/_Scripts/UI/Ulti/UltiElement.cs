using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UltiElement : MonoBehaviour
{
    [SerializeField] Image myFillImg;
    [SerializeField] Image cross;

    [SerializeField] float speedFill = 0.5f;

    Coroutine myCurrentCoroutine;

    bool state = false;

    public void Fill()
    {
        if (state) { return; }

        state = true;
        myFillImg.gameObject.SetActive(true);
        cross.gameObject.SetActive(false);
    }

    public void UnFill()
    {
        if (!state) { return; }

        state = false;
        myFillImg.gameObject.SetActive(false);
        cross.gameObject.SetActive(true);
    }

    public void InstantSetValue(int value)
    {
        myFillImg.fillAmount = value;

        if (value == 1)
        {
            state = true;
            myFillImg.gameObject.SetActive(true);
            cross.gameObject.SetActive(false);
        }
        else
        {
            state = false;
            myFillImg.gameObject.SetActive(false);
            cross.gameObject.SetActive(false);
        }
    }
}
