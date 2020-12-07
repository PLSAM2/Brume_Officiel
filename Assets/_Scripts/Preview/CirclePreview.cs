using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CirclePreview : MonoBehaviour
{
    [SerializeField] GameObject myObjCenter;
    [SerializeField] Image myImgCenter;
    [SerializeField] Image myImgCenterOutline;

    [SerializeField] GameObject myObjBorder;
    [SerializeField] Image myImgBorder;
    [SerializeField] Image myImgBorderOutline;

    public void Init(float _newRaduis, circleCenter _newCenter, Vector3 _newPos)
    {
        Image currentSquare = myImgBorder;
        GameObject currentObj = myObjBorder;

        if (_newCenter == circleCenter.center)
        {
            currentSquare = myImgCenter;
            currentObj = myObjCenter;

            myObjBorder.SetActive(false);
            myObjCenter.SetActive(true);
        }
        else
        {
            myObjBorder.SetActive(true);
            myObjCenter.SetActive(false);
        }

        currentObj.transform.localScale = new Vector3(_newRaduis*2, _newRaduis*2, 1);

        transform.localPosition = _newPos + Vector3.up * 0.1f;
    }

    public void SetColor(Color _newColor, float _newTransparency)
    {
        myImgCenter.color =  _newColor;
        myImgCenter.color = new Color(myImgCenter.color.r, myImgCenter.color.g, myImgCenter.color.b, _newTransparency);
        myImgCenterOutline.color = _newColor;

        myImgBorder.color = _newColor;
        myImgBorder.color = new Color(myImgBorder.color.r, myImgBorder.color.g, myImgBorder.color.b, _newTransparency);
        myImgBorderOutline.color = _newColor;
    }

    public void SetLifeTime ( float _time )
    {
        StartCoroutine(WaitToDisable(_time));
    }


    IEnumerator WaitToDisable ( float _time )
    {
        yield return new WaitForSeconds(_time);
        PreviewManager.Instance.ReleasePreview(gameObject);
    }

    public enum circleCenter
    {
        center,
        border
    }
}
