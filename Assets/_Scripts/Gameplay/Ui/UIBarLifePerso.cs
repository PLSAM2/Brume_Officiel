using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIBarLifePerso : MonoBehaviour
{
    public List<Image> allImgLife = new List<Image>();

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
        allImgLife[0].fillAmount = 1;
    }

    public void HideLife()
    {
        allImgLife[0].fillAmount = 0;
    }

    public void CrackLife()
    {
        if (!isFull) { return; }

        isFull = false;
        StartCoroutine(WaitToDisable());
    }

    public void SetFillAmount ( float _fill )
    {
        allImgLife[0].fillAmount = _fill;
    }


    IEnumerator WaitToDisable ()
    {
        crackObj.SetActive(true);
        yield return new WaitForSeconds(0.4f);
        crackObj.SetActive(false);
    }
}
