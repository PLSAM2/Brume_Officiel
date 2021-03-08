using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class samTest : MonoBehaviour
{
    private void Update()
    {
        //Vector3 _currentMousePos = mousePos();
        //transform.LookAt(new Vector3(_currentMousePos.x, transform.position.y, _currentMousePos.z));

        Vector3 targetDir = mousePos() - transform.position;
        targetDir = new Vector3(Mathf.Clamp(targetDir.x, -1, 1), 0, Mathf.Clamp(targetDir.z, -1, 1));
    }

    float CalculateAngle180_v3(Vector3 fromDir, Vector3 toDir)
    {
        float angle = Quaternion.FromToRotation(fromDir, toDir).eulerAngles.y;
        if (angle > 180) { return angle - 360f; }
        return angle;
    }

    public Vector3 mousePos()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit))
        {
            return new Vector3(hit.point.x, 0, hit.point.z);
        }
        else
        {
            return Vector3.zero;
        }
    }
}
