using AdvancedDissolve_Example;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamTest : MonoBehaviour
{
    [SerializeField] Renderer brumeRenderer;
    [SerializeField] Controller_Mask_Sphere myScript;


    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            print("in");
            myScript.invert = true;
            brumeRenderer.enabled = false;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            print("out");
            myScript.invert = false;
            brumeRenderer.enabled = true;
        }
    }
}
