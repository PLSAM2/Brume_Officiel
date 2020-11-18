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

        float velocityX = (gameObject.transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (gameObject.transform.position.z - oldPos.z) / Time.deltaTime;

        velocityX = Mathf.Clamp(velocityX, -1, 1);
        velocityZ = Mathf.Clamp(velocityZ, -1, 1);

        Vector3 pos = new Vector3(velocityX, 0, velocityZ);

        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        myAnimator.SetFloat("Forward", Mathf.Lerp(myAnimator.GetFloat("Forward"), forward, Time.deltaTime * speed));
        myAnimator.SetFloat("Turn", Mathf.Lerp(myAnimator.GetFloat("Turn"), right, Time.deltaTime * speed));

        oldPos = transform.position;
    }
}
