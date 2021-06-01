using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AltarUiProgressCollider : MonoBehaviour
{
    public Altar parentAltar;
    public List<PlayerModule> playerInUIZone = new List<PlayerModule>();

    private void OnTriggerEnter(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, parentAltar.playerLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }
            if (!playerInUIZone.Contains(_pModule))
            {
               playerInUIZone.Add(_pModule);
            }

            if (!_pModule.mylocalPlayer.isOwner)
            {
                playerInUIZone.RemoveAll(item => item == null);

                if (!IsplayerInUIZoneContainLocalPlayer())
                {
                    return;
                }
            }

            parentAltar.UpdateUI();

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

            if (playerInUIZone.Contains(_pModule))
            {
                playerInUIZone.Remove(_pModule);
            }


            if (_pModule.mylocalPlayer.isOwner)
            {
                UiManager.Instance.SetAltarCaptureUIState(false);
                return;
            }


            parentAltar.UpdateUI();

        }
    }


    public virtual bool IsplayerInUIZoneContainLocalPlayer()
    {
        if (GameFactory.GetActualPlayerFollow() != null)
        {
            return playerInUIZone.Contains(GameFactory.GetActualPlayerFollow().myPlayerModule);
        } else
        {
            return false;
        }

    }



}
