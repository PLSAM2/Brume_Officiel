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
    [SerializeField] SpriteRenderer mapIcon;
    [SerializeField] Sprite iconYang, iconYin;

    [SerializeField] GameObject redObj;
    [SerializeField] GameObject blueObj;

    private void OnEnable()
    {
        networkedObject = GetComponent<NetworkedObject>();

        playerSoul.soulInfo = RoomManager.Instance.actualRoom.playerList[networkedObject.GetOwnerID()];
        if (playerSoul.soulInfo.playerTeam == Team.red)
        {
            mapIcon.color = Color.red;
        }
        else
		{
            mapIcon.color = Color.blue;
        }

        redObj.SetActive(playerSoul.soulInfo.playerTeam == Team.red);
        blueObj.SetActive(playerSoul.soulInfo.playerTeam == Team.blue);

        if (playerSoul.soulInfo.playerCharacter == Character.Re)
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
                || playerSoul.soulInfo.playerTeam != _p.teamIndex)
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
