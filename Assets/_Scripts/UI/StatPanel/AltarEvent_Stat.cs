using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class AltarEvent_Stat : MonoBehaviour
{
    public Image icon;
    public TextMeshProUGUI text;

    public CanvasGroup canvasGroup;

    public void Hide()
    {
        canvasGroup.alpha = 0;
    }

    public void Show()
    {
        canvasGroup.alpha = 1;
    }
}
