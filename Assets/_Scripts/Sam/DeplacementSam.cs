using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeplacementSam : MonoBehaviour
{
    public Animator myAnimator;

    Vector3 oldPos;

    [SerializeField] Camera myCam;

    [SerializeField] LayerMask ground;

    [SerializeField] float speed = 10;

    private void Start()
    {
        oldPos = transform.position;
    }

    void Update()
    {
        RaycastHit hit;
        Ray ray = myCam.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out hit, Mathf.Infinity, ground))
        {
            transform.position = hit.point;
        }
    }
}
