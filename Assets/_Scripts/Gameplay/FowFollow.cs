using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FowFollow : MonoBehaviour
{
    public Transform myTarget;
    [SerializeField] bool isStatic = false;


    [SerializeField] FieldOfView myFieldOfView;

    [SerializeField] float followSpeed = 10;

    public void Init(Transform _target = null)
    {
        if(_target != null)
        {
            isStatic = false;
            myTarget = _target;
        }
        else
        {
            isStatic = true;
            myFieldOfView.GenerateFowStatic();
        }
    }

    public void ChangeRange(float _range)
    {
        myFieldOfView.viewRadius = _range;
    }

    // Update is called once per frame
    void Update()
    {
        if (isStatic) { return; }

        transform.position = Vector3.Lerp(transform.position, myTarget.position, Time.deltaTime * followSpeed);
    }
}
