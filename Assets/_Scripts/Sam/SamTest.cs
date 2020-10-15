using AdultLink;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamTest : MonoBehaviour
{
    [SerializeField] List<Material> matInBrume = new List<Material>();

    [SerializeField] Renderer brumeRenderer;

    [SerializeField] Camera cameraDefault;
    [SerializeField] Camera cameraInBrume;

    [SerializeField] List<Material> matSkin = new List<Material>();

    [SerializeField] SetPosition script;

    [SerializeField] GameObject circle;

    [SerializeField] Animator myAnimator;

    [SerializeField] AnimationCurve curveAlpha;

    private void Start()
    {
        foreach (Material mat in matSkin)
        {
            mat.SetFloat("_Invert", 0);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            if (other.GetComponent<LocalPlayer>().isOwner)
            {
                print("in");
                brumeRenderer.enabled = false;
                cameraDefault.gameObject.SetActive(false);
                cameraInBrume.gameObject.SetActive(true);

                script.enabled = true;
                circle.SetActive(true);

                myAnimator.SetBool("InBrume", true);

                /*
                foreach (Material mat in matInBrume)
                {
                    mat.SetFloat("_Invert", 0);
                }*/

                foreach (Material mat in matSkin)
                {
                    mat.SetFloat("_Invert", 1);
                }
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            if (other.gameObject == GameManager.Instance.currentLocalPlayer.gameObject)
            {
                float distance = Vector3.Distance(other.transform.position, transform.position);


            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            if (other.GetComponent<LocalPlayer>().isOwner)
            {
                print("out");
                brumeRenderer.enabled = true;
                cameraDefault.gameObject.SetActive(true);
                cameraInBrume.gameObject.SetActive(false);

                script.enabled = false;
                circle.SetActive(false);

                myAnimator.SetBool("InBrume", false);

                /*
                foreach (Material mat in matInBrume)
                {
                    mat.SetFloat("_Invert", 1);
                }*/

                foreach (Material mat in matSkin)
                {
                    mat.SetFloat("_Invert", 0);
                }
            }
        }
    }
}
