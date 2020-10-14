using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamTest : MonoBehaviour
{
    [SerializeField] Renderer brumeRenderer;

    [SerializeField] Camera cameraDefault;
    [SerializeField] Camera cameraInBrume;


    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            print("in");
            brumeRenderer.enabled = false;
            cameraDefault.gameObject.SetActive(false);
            cameraInBrume.gameObject.SetActive(true);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            print("out");
            brumeRenderer.enabled = true;
            cameraDefault.gameObject.SetActive(true);
            cameraInBrume.gameObject.SetActive(false);
        }
    }
}
