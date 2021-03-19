using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

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

        if (_fill == 1)
        {
            allImgLife[0].rectTransform.DOScale(new Vector3 (1.2f,1.2f,1), .05f).OnComplete(()=> allImgLife[0].rectTransform.DOScale(new Vector3(1f, 1f, 1), .2f));
        }
    }


    IEnumerator WaitToDisable ()
    {
        crackObj.SetActive(true);
        yield return new WaitForSeconds(0.4f);
        crackObj.SetActive(false);
    }
}
