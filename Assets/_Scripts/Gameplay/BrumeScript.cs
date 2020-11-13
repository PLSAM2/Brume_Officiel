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

    [SerializeField] LayerMask brumeMask;
    [SerializeField] float rangeFilter = 1;


    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            PlayerModule player = other.GetComponent<PlayerModule>();
            player.SetInBrumeStatut(true);

            if (player.mylocalPlayer.isOwner)
            {
                myAnimator.SetBool("InBrume", true);
                SetWardFow(false);

                groundImg.SetActive(true);
                myRenderer.enabled = false;
            }
        }
    }

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
                RaycastHit hit;
                Vector3 fromPosition = transform.position;
                Vector3 toPosition = other.transform.position;
                Vector3 direction = toPosition - fromPosition;


                if (Physics.Raycast(transform.position, direction, out hit, Mathf.Infinity, brumeMask))
                {
                    float distance = Vector3.Distance(other.transform.position, transform.position);
                    UiManager.Instance.SetAlphaBrume(curveAlpha.Evaluate(Mathf.Clamp(Vector3.Distance(other.transform.position, hit.point), 0 , 1)));
                }
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule player = other.GetComponent<PlayerModule>();
            player.SetInBrumeStatut(false);

            if (player.mylocalPlayer.isOwner)
            {
                myAnimator.SetBool("InBrume", false);
                SetWardFow(true);

                UiManager.Instance.SetAlphaBrume(0);
                groundImg.SetActive(false);
                myRenderer.enabled = true;
            }
        }
    }

    void SetWardFow(bool _value)
    {
        GameManager.Instance.allWard.RemoveAll(x => x == null);

        foreach (Ward ward in GameManager.Instance.allWard)
        {
            if(ward == null) { continue; }
            ward.GetFow().gameObject.SetActive(_value);
        }
    }
}
