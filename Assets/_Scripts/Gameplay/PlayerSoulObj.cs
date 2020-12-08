using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class PlayerSoulObj : MonoBehaviour
{
    public Character[] authorizedCaptureCharacter = new Character[1];
    public ushort playerSoul = 0;

    private NetworkedObject networkedObject;
    [SerializeField] SpriteRenderer mapIcon;
    [SerializeField] Sprite iconYang, iconYin;

    [SerializeField] GameObject redObj;
    [SerializeField] GameObject blueObj;

    private void OnEnable()
    {
        networkedObject = GetComponent<NetworkedObject>();

        playerSoul = networkedObject.GetOwnerID();

        if (RoomManager.Instance.GetPlayerData(playerSoul).playerTeam == Team.red)
        {
            mapIcon.color = Color.red;
        }
        else
		{
            mapIcon.color = Color.blue;
        }

        redObj.SetActive(RoomManager.Instance.GetPlayerData(playerSoul).playerTeam == Team.red);
        blueObj.SetActive(RoomManager.Instance.GetPlayerData(playerSoul).playerTeam == Team.blue);

        if (RoomManager.Instance.GetPlayerData(playerSoul).playerCharacter == Character.Re)
            mapIcon.sprite = iconYang;
        else
            mapIcon.sprite = iconYin;

    }

    private void OnTriggerEnter(Collider other)
    {

        if (other.gameObject.layer == 8)
        {
            PlayerModule _p = other.gameObject.GetComponent<PlayerModule>();

            if (GameFactory.GetLocalPlayerObj() != null)
            {
                if (GameFactory.GetLocalPlayerObj().myPlayerModule != _p)
                {
                    return;
                }
            }

            if (_p == null
                || !authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_p.mylocalPlayer.myPlayerId].playerCharacter)
                || RoomManager.Instance.GetPlayerData(playerSoul).playerTeam != _p.teamIndex)
                return;

            PickSoul(_p);
        }
    }


    private void PickSoul(PlayerModule shili)
    {
        if (shili.mylocalPlayer.isOwner)
        {
            WxController wxController = (WxController)shili;

            wxController.PickPlayerSoul(playerSoul);

            NetworkObjectsManager.Instance.DestroyNetworkedObject(networkedObject.GetItemID(), true); //Bypass owner cause created by server
        }
    }
}
