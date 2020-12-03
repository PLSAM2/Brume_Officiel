using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class BrumeScript : MonoBehaviour
{
    [SerializeField] AnimationCurve curveAlpha;

    public Renderer myRenderer;

    [SerializeField] LayerMask brumeMask;
    [SerializeField] float rangeFilter = 1;

    [SerializeField] AudioClip sfxTransiBrume;

    private void Start()
    {
        GameManager.Instance.allBrume.Add(this);
    }


    public void OnSimulateEnter(GameObject obj)
    {
        OnTriggerEnter(obj.GetComponent<Collider>());
    }

    public void OnSimulateExit(GameObject obj)
    {
        OnTriggerExit(obj.GetComponent<Collider>());
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 8)
        {
            PlayerModule player = other.GetComponent<PlayerModule>();

            if (player.isInBrume && player.brumeId == GetInstanceID()) { return; }

            player.SetInBrumeStatut(true, GetInstanceID());

            PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

            if (player == currentFollowPlayer)
            {
                GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", true);
                SetWardFow(player);
                SetTowerFow(false);

                myRenderer.enabled = false;

                AudioManager.Instance.Play2DAudio(sfxTransiBrume);
            }
        }

        if (other.gameObject.layer == 23)
        {
            NetworkedObject netObj = other.gameObject.GetComponent<NetworkedObject>();

            if (netObj.GetIsOwner())
            {
                PlayerModule player = GameManager.Instance.networkPlayers[netObj.GetOwnerID()].myPlayerModule;
                player.SetInBrumeStatut(true, GetInstanceID());


                GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", true);
                SetWardFow(player);
                SetTowerFow(false);

                myRenderer.enabled = false;

                other.GetComponent<Ghost>().currentIdBrume = GetInstanceID();

                AudioManager.Instance.Play2DAudio(sfxTransiBrume);
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

            if (!currentFollowPlayer.isInBrume) { return; }

            GameObject currentPlayerObj = currentFollowPlayer.gameObject;

            if (currentFollowPlayer.isInGhost)
            {
                UiManager.Instance.SetAlphaBrume(0);
            }

            if (other.gameObject == currentPlayerObj)
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

            if (!player.isInBrume || player.brumeId != GetInstanceID()) { return; }

            player.SetInBrumeStatut(false, 0);

            PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

            if (player == currentFollowPlayer)
            {
                GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", false);
                SetWardFow(player);
                SetTowerFow(true);

                UiManager.Instance.SetAlphaBrume(0);
                myRenderer.enabled = true;

                AudioManager.Instance.Play2DAudio(sfxTransiBrume);
            }
        }

        if (other.gameObject.layer == 23)
        {
            NetworkedObject netObj = other.gameObject.GetComponent<NetworkedObject>();

            if (netObj.GetIsOwner())
            {
                PlayerModule player = GameManager.Instance.networkPlayers[netObj.GetOwnerID()].myPlayerModule;
                player.SetInBrumeStatut(false, 0);

                GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", false);
                SetWardFow(player);
                SetTowerFow(true);

                UiManager.Instance.SetAlphaBrume(0);
                myRenderer.enabled = true;

                AudioManager.Instance.Play2DAudio(sfxTransiBrume);
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

    void SetTowerFow(bool value)
    {
        GameManager.Instance.allTower.RemoveAll(x => x == null);

        foreach (VisionTower tower in GameManager.Instance.allTower)
        {
            if (tower == null) { continue; }
            tower.vision.gameObject.SetActive(value);
        }
    }
}
