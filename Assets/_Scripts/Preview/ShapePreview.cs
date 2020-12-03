﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShapePreview : MonoBehaviour
{
    [SerializeField] GameObject objImg;
    [SerializeField] Image myImg;

    public void Init(float _newRange, float _newAngle, float _newRotation, Vector3 _newPos)
    {
        print(_newAngle);
        objImg.transform.localScale = new Vector3(_newRange, _newRange, _newRange);

        myImg.fillAmount = (float)_newAngle / 360;
        transform.eulerAngles = new Vector3(0, 180 + (-(float)_newAngle / 2) + _newRotation, 0);

        transform.localPosition = _newPos + Vector3.up * 0.1f;
    }

    public void SetColor(Color _newColor)
    {
        myImg.color = _newColor;
    }
}
