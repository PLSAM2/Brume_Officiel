using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class BrumeScript : MonoBehaviour
{
    [SerializeField] Animator myAnimator;

    [SerializeField] AnimationCurve curveAlpha;

    [SerializeField] Renderer myRenderer;
    [SerializeField] GameObject groundImg;

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            PlayerModule player = other.GetComponent<PlayerModule>();
            player.isInBrume = true;

            if (player.mylocalPlayer.isOwner)
            {
                myAnimator.SetBool("InBrume", true);

                enterDistance = Vector3.Distance(other.transform.position, transform.position);
                groundImg.SetActive(true);
                myRenderer.enabled = false;
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
                myAnimator.SetBool("InBrume", false);
                UiManager.Instance.SetAlphaBrume(0);
                groundImg.SetActive(false);
                myRenderer.enabled = true;
            }
        }
    }
}
