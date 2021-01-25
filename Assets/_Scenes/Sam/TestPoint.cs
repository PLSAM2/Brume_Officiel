using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestPoint : MonoBehaviour
{
    public Transform sphere;

    public LayerMask mask;

    float viewAngle = 360;

    public float resolution = 1;

    void Update()
    {
        int stepCount = Mathf.RoundToInt(viewAngle * resolution);
        float stepAngleSize = viewAngle / stepCount;
        List<Vector3> viewPoints = new List<Vector3>();

        for (int i = 0; i <= stepCount; i++)
        {
            float angle = transform.eulerAngles.y - viewAngle / 2 + stepAngleSize * i;

            Vector3 dir = DirFromAngle(angle, true);
            RaycastHit hit;

            float distance = 10;

            if (Physics.Raycast(transform.position, dir, out hit, 10))
            {
                distance = hit.distance;
            }

            Debug.DrawRay(transform.position, dir, Color.red, 0.1f);
        }
    }

    public Vector3 DirFromAngle(float angleInDegrees, bool angleIsGlobal)
    {
        if (!angleIsGlobal)
        {
            angleInDegrees += transform.eulerAngles.y;
        }
        return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
    }
}
