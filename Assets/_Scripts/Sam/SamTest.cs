using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class SamTest : MonoBehaviour
{
    [SerializeField] List<Material> matInBrume = new List<Material>();

    [SerializeField] Camera cameraDefault;
    [SerializeField] Camera cameraInBrume;

    [SerializeField] List<Material> matSkin = new List<Material>();

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
            PlayerModule player = other.GetComponent<PlayerModule>();
            player.isInBrume = true;

            if (player.mylocalPlayer.isOwner)
            {
                cameraDefault.gameObject.SetActive(false);
                cameraInBrume.gameObject.SetActive(true);

                myAnimator.SetBool("InBrume", true);

                /*
                foreach (Material mat in matInBrume)
                {
                    mat.SetFloat("_Invert", 0);
                }*/

                foreach (Material mat in matSkin)
                {
                    mat.SetFloat("_Invert", 1);
                    mat.SetFloat("_Radius", transform.localScale.x + 0.5f);
                }

                enterDistance = Vector3.Distance(other.transform.position, transform.position);
            }
        }
    }

    float enterDistance = 0;
    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            if (GameManager.Instance.currentLocalPlayer == null)
            {
                return;
            }
            if (other.gameObject == GameManager.Instance.currentLocalPlayer.gameObject)
            {
                float distance = Vector3.Distance(other.transform.position, transform.position);
                UiManager.Instance.SetAlphaBrume(curveAlpha.Evaluate(enterDistance - distance));
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule player = other.GetComponent<PlayerModule>();
            player.isInBrume = false;

            if (player.mylocalPlayer.isOwner)
            {
                cameraDefault.gameObject.SetActive(true);
                cameraInBrume.gameObject.SetActive(false);

                myAnimator.SetBool("InBrume", false);

                /*
                foreach (Material mat in matInBrume)
                {
                    mat.SetFloat("_Invert", 1);
                }*/

                foreach (Material mat in matSkin)
                {
                    mat.SetFloat("_Invert", 0);
                    mat.SetFloat("_Radius", 1);
                }

                UiManager.Instance.SetAlphaBrume(0);
            }
        }
    }
}
