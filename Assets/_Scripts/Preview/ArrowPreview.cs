using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ArrowPreview : MonoBehaviour
{
    [SerializeField] Transform arrowParent;
    [SerializeField] SpriteRenderer arrowImgDash;
    [SerializeField] SpriteRenderer arrowImgProjectil;
    [SerializeField] Transform endArrowDash, endArrowProjectil;
    [SerializeField] LineRenderer line;

    [SerializeField] Transform previewSprite;

    Vector3 startPos, endPos;

    arrowType currentType;

    public void Init(Vector3 _newStartPos, Vector3 _newEndPos, arrowType _myType)
    {
        currentType = _myType;

        arrowImgDash.enabled = (_myType == arrowType.Dash);
        arrowImgProjectil.enabled = (_myType == arrowType.Projectil);

        startPos = _newStartPos;
        endPos = _newEndPos;

        Quaternion rotation = Quaternion.LookRotation((_newStartPos - _newEndPos).normalized, Vector3.up);
        previewSprite.rotation = rotation;
        previewSprite.localEulerAngles = new Vector3(previewSprite.localEulerAngles.x + 90, previewSprite.localEulerAngles.y + 90, previewSprite.localEulerAngles.z);
        previewSprite.localScale = new Vector3( Vector3.Distance(_newStartPos, _newEndPos), 1, 1);
    }

    public void SetColor(Color _newColor)
    {
        arrowImgDash.color = _newColor;
        arrowImgProjectil.color = _newColor;
    }

    void Update()
    {
        transform.position = startPos + Vector3.up * 0.1f;
        arrowParent.transform.position = endPos + Vector3.up * 0.1f;

        line.SetPosition(0, startPos);
        line.SetPosition(1, (currentType == arrowType.Dash ? endArrowDash.position : endArrowProjectil.position));

        arrowParent.LookAt(startPos);
        arrowParent.localEulerAngles = new Vector3(0, arrowParent.localEulerAngles.y, arrowParent.localEulerAngles.z);
    }

    public enum arrowType
    {
        Dash,
        Projectil
    }
}
