using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class RoomPanelControl : MonoBehaviour
{
    public TextMeshProUGUI roomName;

    public GameObject playerList;
    public GameObject playerListObj;
    public GameObject startGameButton;
    public Dictionary<PlayerData, PlayerListObj> PlayerObjDict = new Dictionary<PlayerData, PlayerListObj>();
    public void InitRoom(RoomData roomData)
    {
        roomName.text = roomData.Name;

        foreach (Transform item in playerList.transform)
        {
            Destroy(item.gameObject);
        }

        PlayerObjDict.Clear();

        foreach (KeyValuePair<ushort, PlayerData> p in roomData.playerList)
        {
            AddPlayer(p.Value);
        }

    }

    public void AddPlayer(PlayerData player)
    {
        GameObject tempPlayerListObj = Instantiate(playerListObj, playerList.transform);

        PlayerListObj obj = tempPlayerListObj.GetComponent<PlayerListObj>();
        obj.playerName.text = player.Name;
        PlayerObjDict.Add(player, obj);

        if (player.IsHost == true)
        {
            SetHost(player, true);
        }
    }

    public void RemovePlayer(PlayerData player)
    {
        SetHost(player, false);
        Destroy(PlayerObjDict[player].gameObject);
        PlayerObjDict.Remove(player);
    }

    public void SetHost(PlayerData player, bool value)
    {
        PlayerObjDict[player].host.SetActive(value);

        if (LobbyManager.Instance.localPlayer.IsHost)
        {
            startGameButton.SetActive(true);
        }
    }
}
