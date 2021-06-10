using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AltarUiProgressCollider : MonoBehaviour
{
    public Altar parentAltar;
    public Dictionary<ushort,  PlayerModule> playersInUIZone = new Dictionary<ushort, PlayerModule>();

    private void OnTriggerEnter(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, parentAltar.playerLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }
            if (!playersInUIZone.ContainsKey(_pModule.mylocalPlayer.myPlayerId))
            {
               playersInUIZone.Add(_pModule.mylocalPlayer.myPlayerId, _pModule);
            }

            if (!_pModule.mylocalPlayer.isOwner)
            {
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

            if (playersInUIZone.ContainsKey(_pModule.mylocalPlayer.myPlayerId))
            {
                playersInUIZone.Remove(_pModule.mylocalPlayer.myPlayerId);
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
            return playersInUIZone.ContainsKey(GameFactory.GetActualPlayerFollow().myPlayerId);
        } else
        {
            return false;
        }

    }



}
