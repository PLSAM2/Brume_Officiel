using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ArrowPreview : MonoBehaviour
{
    [SerializeField] Transform arrowParent;
    [SerializeField] SpriteRenderer arrowImg;
    [SerializeField] Transform endArrow;
    [SerializeField] LineRenderer line;

    [SerializeField] Transform previewSprite;

    Vector3 startPos, endPos;

    public void Init(Vector3 _newStartPos, Vector3 _newEndPos, float _startWidth = 0, float _endWidth = 0)
    {
        if(_startWidth != 0)
        {
            line.startWidth = _startWidth;
        }

        if (_endWidth != 0)
        {
            line.endWidth = _endWidth;
        }

        startPos = _newStartPos;
        endPos = _newEndPos;

        Quaternion rotation = Quaternion.LookRotation((_newStartPos - _newEndPos).normalized, Vector3.up);
        previewSprite.rotation = rotation;
        previewSprite.localEulerAngles = new Vector3(previewSprite.localEulerAngles.x + 90, previewSprite.localEulerAngles.y + 90, previewSprite.localEulerAngles.z);
        previewSprite.localScale = new Vector3( Vector3.Distance(_newStartPos, _newEndPos), 1, 1);
    }

    public void SetColor(Color _newColor)
    {
        arrowImg.color = _newColor;
    }

    void Update()
    {
        transform.position = startPos + Vector3.up * 0.1f;
        arrowParent.transform.position = endPos + Vector3.up * 0.1f;

        line.SetPosition(0, startPos);
        line.SetPosition(1, endArrow.position);

        arrowParent.LookAt(startPos);
        arrowParent.localEulerAngles = new Vector3(0, arrowParent.localEulerAngles.y, arrowParent.localEulerAngles.z);
    }
}
