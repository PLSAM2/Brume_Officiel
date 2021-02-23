using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class samTest : MonoBehaviour
{
    Vector3 newNetorkPos;
    public Vector3 oldPos;

    [SerializeField] Animator animator;

    public float speedoo = 00.01f;

    private void Update()
    {
        //newNetorkPos += new Vector3( Input.GetAxis("Horizontal") * speed, 0, Input.GetAxis("Vertical") * speed);

        //transform.position = Vector3.MoveTowards(transform.position, newNetorkPos, Vector3.Distance(transform.position, newNetorkPos) * 10);
        DoAnimation();
    }

    private void DoAnimation()
    {
        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;

        float speed = 4;

        velocityX = velocityX / speed;
        velocityZ = velocityZ / speed;

        Vector3 pos = Vector3.Lerp(oldPos, new Vector3(velocityX, 0, velocityZ), Time.deltaTime * speedoo);

        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        animator.SetFloat("Forward", forward);
        animator.SetFloat("Turn", right);

        oldPos = transform.position;
    }
}
