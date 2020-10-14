using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamTest : MonoBehaviour
{
    void Update()
    {
        Vector3 move = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
        transform.position += move * Time.deltaTime * 10;
    }
}
