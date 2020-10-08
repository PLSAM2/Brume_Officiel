using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class RoomListObj : MonoBehaviour
{
    public TextMeshProUGUI roomName;
    public TextMeshProUGUI playerNumber;
    public ushort roomID;

    public void Init(RoomData room, ushort playerNumber, ushort ID)
    {
        this.roomName.text = room.Name;
        this.playerNumber.text = playerNumber + "/" + room.MaxPlayers;
        roomID = ID;
    }

    public void JoinGame()
    {
        LobbyManager.Instance.JoinRoom(roomID);
    }
}
