using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class RoomPanelControl : SerializedMonoBehaviour
{
    public TextMeshProUGUI roomName;

    public GameObject redPlayerList;
    public GameObject bluePlayerList;
    public GameObject specPlayerList;
    public GameObject playerListObj;
    public GameObject startGameButton;
    public GameObject readyButton;
    public GameObject joinSpecButton;
    public GameObject Swap;
    public GameObject JoinTeam;
    public Dictionary<ushort, PlayerListObj> PlayerObjDict = new Dictionary<ushort, PlayerListObj>();

    public void InitRoom(RoomData roomData)
    {
        roomName.text = roomData.Name;
        startGameButton.SetActive(false);

        foreach (Transform item in bluePlayerList.transform)
        {
            Destroy(item.gameObject);
        }
        foreach (Transform item in redPlayerList.transform)
        {
            Destroy(item.gameObject);
        }
        foreach (Transform item in specPlayerList.transform)
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
        startGameButton.SetActive(false);

        GameObject _PlayerListObj;

        switch (player.playerTeam)
        {
            case Team.none:
                return;
            case Team.red:
                _PlayerListObj = Instantiate(playerListObj, redPlayerList.transform);
                break;
            case Team.blue:
                _PlayerListObj = Instantiate(playerListObj, bluePlayerList.transform);
                break;
            case Team.spectator:
                _PlayerListObj = Instantiate(playerListObj, specPlayerList.transform);
                break;
            default:
                return;
        }

        PlayerListObj obj = _PlayerListObj.GetComponent<PlayerListObj>();

        obj.playerName.text = player.Name;
        PlayerObjDict.Add(player.ID, obj);

        SetReady(player.ID, player.IsReady);

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
            case Team.spectator:
                PlayerObjDict[playerID].gameObject.transform.SetParent(specPlayerList.transform);
                break;
            default:
                print("Error");
                break;
        }
    }

    public void SwapTeam()
    {
        LobbyManager.Instance.SetReady(false);

        switch (NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            case Team.red:
                LobbyManager.Instance.ChangeTeam(Team.blue);
                break;
            case Team.blue:
                LobbyManager.Instance.ChangeTeam(Team.red);
                break;
            case Team.spectator:
                LobbyManager.Instance.ChangeTeam(Team.red);
                readyButton.SetActive(true);
                joinSpecButton.SetActive(true);
                Swap.SetActive(true);
                JoinTeam.SetActive(false);
                break;
            default:
                print("Error");
                break;
        }
    }

    public void JoinSpectator()
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
        {
            SwapTeam();
        }
        else
        {
            LobbyManager.Instance.ChangeTeam(Team.spectator);
            readyButton.SetActive(false);
            joinSpecButton.SetActive(false);
            Swap.SetActive(false);
            JoinTeam.SetActive(true);
            LobbyManager.Instance.SetReady(true);
        }


    }

    public void SetReady(ushort playerID, bool value)
    {
        PlayerObjDict[playerID].readyImg.SetActive(value);


        if (NetworkManager.Instance.GetLocalPlayer().IsHost)
        {
            bool onlySpec = true;

            foreach (KeyValuePair<ushort, PlayerData> p in RoomManager.Instance.actualRoom.playerList)
            {
                if (p.Value.playerTeam != Team.spectator)
                {
                    onlySpec = false;
                    break;
                }
            }

            if (onlySpec)
            {
                startGameButton.SetActive(false);
                return;
            }


            foreach (KeyValuePair<ushort, PlayerData> p in RoomManager.Instance.actualRoom.playerList)
            {
                if (!p.Value.IsReady)
                {
                    startGameButton.SetActive(false);
                    return;
                }
            }

            startGameButton.SetActive(true);
        }

    }

    public void SetReadyBtn()
    {
        if (NetworkManager.Instance.GetLocalPlayer().IsReady)
        {
            LobbyManager.Instance.SetReady(false);
        }
        else
        {
            LobbyManager.Instance.SetReady(true);
        }
    }

    public void StartGame()
    {
        RoomManager.Instance.StartChampSelect();
    }
}
