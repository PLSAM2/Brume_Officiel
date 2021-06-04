using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SquarePreview : MonoBehaviour
{
    [SerializeField] GameObject myObjCenter;

    [SerializeField] GameObject myObjBorder;

    [SerializeField] GameObject borderWX;
    [SerializeField] Transform borderWXStartPos, borderWXEnd, borderWXEndPos;
    [SerializeField] LineRenderer borderWXLine;

    public void Init(float _newLenght, float _newWidth, float _newRotation, squareCenter _newCenter, Vector3 _newPos)
    {
        if (_newCenter == squareCenter.center) {
            myObjBorder.SetActive(false);
            myObjCenter.SetActive(true);
            borderWX.SetActive(false);

            myObjCenter.transform.localScale = new Vector3(_newWidth, _newLenght, 1);
            transform.eulerAngles = new Vector3(0, _newRotation, 0);
        }
        else{
            myObjBorder.SetActive(true);
            myObjCenter.SetActive(false);

            borderWX.SetActive(true);

            borderWXEnd.localPosition = new Vector3(0,0, _newLenght);

            transform.eulerAngles = new Vector3(0, _newRotation, 0);

            borderWXLine.SetPosition(0, borderWXStartPos.position);
            borderWXLine.SetPosition(1, borderWXEndPos.position);
        }

        transform.localPosition = _newPos + Vector3.up * 0.1f;
    }

    public enum squareCenter
    {
        center,
        border
    }
}
