using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ArrowPreview : MonoBehaviour
{
    [SerializeField] Transform arrowParent;
    [SerializeField] Image arrowImg;
    [SerializeField] Transform endArrow;
    [SerializeField] LineRenderer line;

    Vector3 startPos, endPos;

    public void Init(Vector3 _newStartPos, Vector3 _newEndPos, float _startWidth = 0, float _endWidth = 0.3f)
    {
        line.startWidth = _startWidth; 
        line.endWidth = _endWidth;

        startPos = _newStartPos;
        endPos = _newEndPos;
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

        arrowParent.rotation = Quaternion.LookRotation(startPos, Vector3.up);
        //arrowParent.eulerAngles = new Vector3(0, 0, arrowParent.eulerAngles.z - 45);
    }
}
