using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class RoomPanelControl : MonoBehaviour
{
    public TextMeshProUGUI roomName;

    public GameObject playerList;
    public GameObject playerListObj;

    public void InitRoom(RoomData roomData)
    {
        roomName.text = roomData.Name;

        foreach (PlayerData p in roomData.playerList)
        {
            GameObject tempPlayerListObj = Instantiate(playerListObj, playerList.transform);

            PlayerListObj obj = tempPlayerListObj.GetComponent<PlayerListObj>();
            obj.playerName.text = p.Name;

            if (p.IsHost == true)
            {
                obj.host.SetActive(true);
            }

        }
    }
}
