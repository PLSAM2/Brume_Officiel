using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SquarePreview : MonoBehaviour
{
    [SerializeField] GameObject myObjCenter;
    [SerializeField] Image myImgCenter;

    [SerializeField] GameObject myObjBorder;
    [SerializeField] Image myImgBorder;

    public void Init(float _newLenght, float _newWidth, float _newRotation, squareCenter _newCenter, Vector3 _newPos)
    {
        Image currentSquare = myImgBorder;
        GameObject currentObj = myObjBorder;

        if (_newCenter == squareCenter.center) {
            currentSquare = myImgCenter;
            currentObj = myObjCenter;

            myObjBorder.SetActive(false);
            myObjCenter.SetActive(true);
        }
        else{
            myObjBorder.SetActive(true);
            myObjCenter.SetActive(false);
        }

        currentObj.transform.localScale = new Vector3(_newWidth, _newLenght, 1);
        transform.eulerAngles = new Vector3(0, _newRotation, 0);

        transform.localPosition = _newPos + Vector3.up * 0.1f;
    }

    public void SetColor(Color _newColor)
    {
        myImgCenter.color = _newColor;
        myImgBorder.color = _newColor;
    }

    public enum squareCenter
    {
        center,
        border
    }
}
