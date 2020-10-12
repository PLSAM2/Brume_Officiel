using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamTest : MonoBehaviour
{
    [SerializeField] GameObject prefab;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Instantiate(prefab, Vector3.zero + Vector3 .up * 0.5f, new Quaternion(0, Random.Range(0, 360), 0, 0));
        }
    }
}
