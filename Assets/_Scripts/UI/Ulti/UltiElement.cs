using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UltiElement : MonoBehaviour
{
    [SerializeField] Image myFillImg;
    [SerializeField] Image cross;

    [SerializeField] float speedFill = 0.5f;

    bool state = false;

    [SerializeField] Animator gainAnimator;

    public void Fill(bool isLocal)
    {
        if (state) { return; }

        state = true;
        myFillImg.gameObject.SetActive(true);
        cross.gameObject.SetActive(false);

        if (isLocal)
        {
            gainAnimator.SetTrigger("Local");
        }
        else
        {
            gainAnimator.SetTrigger("Other");
        }
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
