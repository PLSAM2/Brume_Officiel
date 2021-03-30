using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookTarget : MonoBehaviour
{
    public Transform target;

    private void Update()
    {
        if(target == null) { return; }

        transform.LookAt(new Vector3(target.position.x, transform.position.y, target.position.z));
    }
}
