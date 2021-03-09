using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIBarLifePerso : MonoBehaviour
{
    [SerializeField] List<Image> allImgLife = new List<Image>();

    [SerializeField] GameObject crackObj;

    bool isFull = true;

    public void Init(Material matColor)
    {
        isFull = true;
        foreach (Image img in allImgLife)
        {
            img.material = matColor;
            img.enabled = true;
        }
    }

    public void SetColorLife(Material matColor, bool state)
    {
        isFull = state;
        allImgLife[0].material = matColor;
        allImgLife[0].enabled = true;
    }

    public void HideLife()
    {
        allImgLife[0].enabled = false;
    }

    public void CrackLife()
    {
        if (!isFull) { return; }

        isFull = false;
        StartCoroutine(WaitToDisable());
    }

    IEnumerator WaitToDisable()
    {
        crackObj.SetActive(true);
        yield return new WaitForSeconds(0.4f);
        crackObj.SetActive(false);
    }
}
