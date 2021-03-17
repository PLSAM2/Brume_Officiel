using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class samTest : MonoBehaviour
{
    public Transform obj;

    public float speed = 4;

    private void Update()
    {
        obj.position = Vector3.Lerp(obj.position, transform.position, speed * Time.deltaTime);
    }
}
