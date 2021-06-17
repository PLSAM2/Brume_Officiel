using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class LabelStatElement : MonoBehaviour
{
    public GameObject selected;

    public bool isActive = false;

    public void OnClick()
    {
        if (isActive) { return; }

        isActive = true;
        selected.SetActive(true);
    }

    public void Disable()
    {
        isActive = false;

        selected.SetActive(false);
    }
}
