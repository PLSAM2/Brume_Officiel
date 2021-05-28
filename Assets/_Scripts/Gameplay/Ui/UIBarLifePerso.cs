using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class UIBarLifePerso : MonoBehaviour
{
    public Image imgLife;

    public bool isFull = true;

    public void Init(Material matColor)
    {
        isFull = true;
        imgLife.material = matColor;
        //imgLife.fillAmount = 0;
    }

    public void ChangeColor(Material matColor)
    {
        imgLife.material = matColor;
    }

    public void SetColorLife(Material matColor, bool state)
    {
        isFull = state;
        imgLife.material = matColor;

        if (isFull)
        {
            imgLife.DOFillAmount(1, 0.4f);
        }
        else
        {
            imgLife.DOFillAmount(0, 0.4f);
        }
    }
}
