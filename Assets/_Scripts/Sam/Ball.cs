﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{
    public float speed = 1;

    // Update is called once per frame
    void Update()
    {
        transform.Translate(transform.forward * speed);

        if (Input.GetKeyDown(KeyCode.Space))
        {
            Destroy(gameObject);
        }
    }
}
