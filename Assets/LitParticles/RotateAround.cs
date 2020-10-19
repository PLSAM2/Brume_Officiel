using UnityEngine;
using System.Collections;

public class RotateAround : MonoBehaviour {

    Quaternion axis;

    [Header("Rotation")]
    public float speed = 5f;

    [Header("Pivot")]
    public Transform targetTransform;

    public static Vector3 RotatePointAroundPivot(Vector3 point, Vector3 pivot, Quaternion angle)
    {
        return angle * (point - pivot) + pivot;
    }

    void FixedUpdate()
    {
        axis = Quaternion.Euler(0f, speed * Time.deltaTime, 0f);

        transform.position = RotatePointAroundPivot(transform.position, targetTransform.position, axis);
        //transform.LookAt(transform.parent.position);
    }
}
