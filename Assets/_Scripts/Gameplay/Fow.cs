using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fow : MonoBehaviour
{
    public Transform myTarget;
    [SerializeField] bool isStatic = false;


    [SerializeField] FieldOfView myFieldOfView;

    [SerializeField] float followSpeed = 10;
    float fowRaduis = 0;

    public void Init(Transform _target = null)
    {
        if(_target != null)
        {
            isStatic = false;
            myTarget = _target;
            fowRaduis = myFieldOfView.viewRadius;
        }
        else
        {
            isStatic = true;
            myFieldOfView.GenerateFowStatic();
        }
    }

    public void ChangeFowRaduis(float _size)
    {
        fowRaduis = _size;
    }

    // Update is called once per frame
    void Update()
    {
        if (isStatic) { return; }

        transform.position = Vector3.Lerp(transform.position, myTarget.position, Time.deltaTime * followSpeed);

        myFieldOfView.viewRadius = Mathf.Lerp(myFieldOfView.viewRadius, fowRaduis, 6 * Time.deltaTime);
    }
}
