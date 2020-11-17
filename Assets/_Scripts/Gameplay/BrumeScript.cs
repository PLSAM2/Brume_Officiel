using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class BrumeScript : MonoBehaviour
{
    [SerializeField] Animator myAnimator;

    [SerializeField] AnimationCurve curveAlpha;

    [SerializeField] Renderer myRenderer;

    [SerializeField] LayerMask brumeMask;
    [SerializeField] float rangeFilter = 1;

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            PlayerModule player = other.GetComponent<PlayerModule>();
            player.SetInBrumeStatut(true, GetInstanceID());

            PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

            if (player == currentFollowPlayer)
            {
                myAnimator.SetBool("InBrume", true);
                SetWardFow(player);

                myRenderer.enabled = false;
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

            if (other.gameObject == currentFollowPlayer.gameObject)
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
            player.SetInBrumeStatut(false, 0);

            PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

            if (player == currentFollowPlayer)
            {
                myAnimator.SetBool("InBrume", false);
                SetWardFow(player);

                UiManager.Instance.SetAlphaBrume(0);
                myRenderer.enabled = true;
            }
        }
    }

    void SetWardFow(PlayerModule _player)
    {
        GameManager.Instance.allWard.RemoveAll(x => x == null);

        foreach (Ward ward in GameManager.Instance.allWard)
        {
            if(ward == null) { continue; }
            bool fogValue = false;

            if (GameFactory.PlayerWardAreOnSameBrume(_player, ward))
            {
                fogValue = true;
            }
            else
            {
                if (_player.isInBrume)
                {
                    fogValue = false;
                }
                else
                {
                    fogValue = true;
                }
            }

            ward.GetFow().gameObject.SetActive(fogValue);
        }
    }
}
