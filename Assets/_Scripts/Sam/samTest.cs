using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class samTest : MonoBehaviour
{
    public float alpha = 1;

    private void Start()
    {
        GetComponent<Renderer>().material = Instantiate<Material>(GetComponent<Renderer>().material);
    }

    private void Update()
    {
        GetComponent<Renderer>().material.SetFloat("_Alpha", alpha);
    }
}
