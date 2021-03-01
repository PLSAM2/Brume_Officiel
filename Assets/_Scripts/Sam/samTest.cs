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

    Vector3 direction;
    private void DoAnimation()
    {
        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;

        float speed = 4;

        velocityX = velocityX / speed;
        velocityZ = velocityZ / speed;

        direction = Vector3.Lerp(direction, new Vector3(velocityX, 0, velocityZ), Time.deltaTime * speedoo);
        //direction = new Vector3(velocityX, 0, velocityZ);

        float right = Vector3.Dot(transform.right, direction);
        float forward = Vector3.Dot(transform.forward, direction);

        animator.SetFloat("Forward", forward);
        animator.SetFloat("Turn", right);

        oldPos = transform.position;
    }
}
