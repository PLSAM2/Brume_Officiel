using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class PlayerSoulObj : MonoBehaviour
{
    public Character[] authorizedCaptureCharacter = new Character[1];
    public PlayerSoul playerSoul = new PlayerSoul();

    private NetworkedObject networkedObject;

    private void OnEnable()
    {
        networkedObject = GetComponent<NetworkedObject>();

        playerSoul.soulInfo = RoomManager.Instance.actualRoom.playerList[networkedObject.GetOwnerID()];
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule _p = other.gameObject.GetComponent<PlayerModule>();

            if (_p == null
                || !authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_p.mylocalPlayer.myPlayerId].playerCharacter)
                || playerSoul.soulInfo.playerTeam != _p.teamIndex)
                return;

            PickSoul(_p);
        }
    }


    private void PickSoul(PlayerModule shili)
    {
        shili.PickPlayerSoul(playerSoul);
        NetworkObjectsManager.Instance.DestroyNetworkedObject(networkedObject.GetItemID(), true); //Bypass owner cause only one player play as Shili
    }
}
