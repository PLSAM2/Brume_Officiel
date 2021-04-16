using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class LabelStatElement : MonoBehaviour
{
    public TextMeshProUGUI textLabel;
    public Image backImg;
    public GameObject line;

    public bool isActive = false;

    public void OnClick()
    {
        if (isActive) { return; }

        isActive = true;
        backImg.gameObject.SetActive(true);
        line.SetActive(true);
        textLabel.fontSize = 48;
        textLabel.color = Color.white;
    }

    public void Disable()
    {
        isActive = false;

        backImg.gameObject.SetActive(false);
        line.SetActive(false);
        textLabel.fontSize = 35;
        textLabel.color = Color.black;
    }
}
