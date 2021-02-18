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
        StartCoroutine(AddValue());
    }

    public void UnFill()
    {
        if (!state) { return; }

        state = false;
        StartCoroutine(SupprValue());
    }

    public void InstantSetValue(int value)
    {
        myFillImg.fillAmount = value;

        if(value == 1)
        {
            state = true;
        }
        else
        {
            state = false;
        }
    }

    IEnumerator AddValue()
    {
        cross.gameObject.SetActive(false);
        float startValue = myFillImg.fillAmount;
        while (myFillImg.fillAmount != 1)
        {
            myFillImg.fillAmount = Mathf.Lerp(startValue, 1, speedFill * Time.deltaTime);
            yield return null;
        }

        yield return null;
    }

    IEnumerator SupprValue()
    {
        cross.gameObject.SetActive(true);
        float startValue = myFillImg.fillAmount;
        while (myFillImg.fillAmount != 0)
        {
            myFillImg.fillAmount = Mathf.Lerp(startValue, 0, speedFill * Time.deltaTime);
            yield return null;
        }

        cross.gameObject.SetActive(false);
        yield return null;
    }
}
