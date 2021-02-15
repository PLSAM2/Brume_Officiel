using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    public CharacterController charac;

    private Vector3 oldPos;

    public float speed = 5;

    void Start()
    {
        oldPos = transform.position;
    }

    private void Update()
    {
        charac.Move(new Vector3(1,0,0) * Time.deltaTime * speed);

        Vector3 velocity = (transform.position - oldPos) / Time.deltaTime;

        print(velocity.x);

        oldPos = transform.position;
    }
}
