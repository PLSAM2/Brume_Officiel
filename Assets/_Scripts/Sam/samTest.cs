using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    public Transform posEnd;

    public float speed = 2.5f;


    private void Update()
    {
        transform.position = Vector3.MoveTowards(transform.position, posEnd.position, speed);
    }
}
