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
        if (playerSoul.soulInfo.playerCharacter == Character.Yang)
            mapIcon.sprite = iconYang;
        else
            mapIcon.sprite = iconYin;
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
