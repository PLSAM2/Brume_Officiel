using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class RoomPanelControl : MonoBehaviour
{
    public TextMeshProUGUI roomName;

    public GameObject redPlayerList;
    public GameObject bluePlayerList;
    public GameObject playerListObj;
    public GameObject startGameButton;
    public Dictionary<ushort, PlayerListObj> PlayerObjDict = new Dictionary<ushort, PlayerListObj>();
    public void InitRoom(RoomData roomData)
    {
        roomName.text = roomData.Name;

        foreach (Transform item in bluePlayerList.transform)
        {
            Destroy(item.gameObject);
        }
        foreach (Transform item in redPlayerList.transform)
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
        GameObject _PlayerListObj;

        if (player.playerTeam == Team.red)
        {
            _PlayerListObj = Instantiate(playerListObj, redPlayerList.transform);
        } else
        {
            _PlayerListObj = Instantiate(playerListObj, bluePlayerList.transform);
        }

        PlayerListObj obj = _PlayerListObj.GetComponent<PlayerListObj>();

        obj.playerName.text = player.Name;

        PlayerObjDict.Add(player.ID, obj);

        if (player.IsHost == true)
        {
            SetHost(player, true);
        }
    }

    public void RemovePlayer(PlayerData player)
    {
        SetHost(player, false);
        Destroy(PlayerObjDict[player.ID].gameObject);
        PlayerObjDict.Remove(player.ID);
    }

    public void SetHost(PlayerData player, bool value)
    {
        PlayerObjDict[player.ID].host.SetActive(value);

        if (LobbyManager.Instance.localPlayer.IsHost)
        {
            startGameButton.SetActive(true);
        }
    }

    public void ChangeTeam(ushort playerID, Team team)
    {
        switch (team)
        {
            case Team.red:
                PlayerObjDict[playerID].gameObject.transform.SetParent(redPlayerList.transform);
                break;
            case Team.blue:
                PlayerObjDict[playerID].gameObject.transform.SetParent(bluePlayerList.transform);
                break;
            default:
                print("Error");
                break;
        }


    }

    public void SwapTeam()
    {

        switch (LobbyManager.Instance.localPlayer.playerTeam)
        {
            case Team.red:
                LobbyManager.Instance.ChangeTeam(Team.blue);
                break;
            case Team.blue:
                LobbyManager.Instance.ChangeTeam(Team.red);
                break;
            default:
                print("Error");
                break;
        }



    }

    


}
