using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class RoomListObj : MonoBehaviour
{
    public TextMeshProUGUI roomName;
    public TextMeshProUGUI playerNumber;
    public ushort roomID;

    public void Init(string roomName, ushort playerNumber, ushort ID)
    {
        this.roomName.text = roomName;
        this.playerNumber.text = playerNumber + "/" + "MAXPLAYER";
        roomID = ID;
    }

    public void JoinGame()
    {
        LobbyManager.Instance.JoinRoom(roomID);
    }
}
