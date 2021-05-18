using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AltarUiProgressCollider : MonoBehaviour
{
    public Altar parentAltar;

    private void OnTriggerEnter(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, parentAltar.playerLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }


            if (!_pModule.mylocalPlayer.isOwner)
            {
                if (!parentAltar.IsLocalPlayerInZoneContainLocalPlayer())
                {
                    return;
                }
            }

            UpdateUI();

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, parentAltar.playerLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }

            if (_pModule.mylocalPlayer.isOwner)
            {
                UiManager.Instance.SetAltarCaptureUIState(false);
                return;
            }


            UpdateUI();

        }
    }

    private void UpdateUI()
    {
        if (parentAltar.GetLocalPlayerCountInZone() <= 0)
        {
            UiManager.Instance.SetAltarCaptureUIState(false);
            return;
        }

        if (parentAltar.IsLocallyContested())
        {
            UiManager.Instance.SetAltarCaptureUIState(true, true) ;
        } else
        {
            if (parentAltar.capturingTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                UiManager.Instance.SetAltarCaptureUIState(true, false, parentAltar.GetLocalPlayerCountInZone());
            }
        }
    }

}
