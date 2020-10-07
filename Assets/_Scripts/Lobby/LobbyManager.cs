using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DarkRift.Client;
using DarkRift.Client.Unity;
using DarkRift;
using System;

public class LobbyManager : MonoBehaviour
{
    [SerializeField] UnityClient client;

    public GameObject roomPanel;
    public GameObject roomListPanel;
    public GameObject mainMenu;
    public RoomPanelControl roomPanelControl;
    public RoomListPanelControl roomListPanelControl;
    public PlayerData localPlayer;


    public Dictionary<ushort, RoomData> rooms = new Dictionary<ushort, RoomData>();
    private RoomData actualRoomIn;


    private static LobbyManager _instance;
    public static LobbyManager Instance { get { return _instance; } }


    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }

        DontDestroyOnLoad(this);

        client.MessageReceived += MessageReceived;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.PlayerConnected)
            {
                using (DarkRiftReader reader = message.GetReader())
                {
                    PlayerData _localPlayer = reader.ReadSerializable<PlayerData>();
                    localPlayer = _localPlayer;
                }
            }

            if (message.Tag == Tags.CreateRoom)
            {
                RoomCreatedInServer(sender, e);
            }

            if (message.Tag == Tags.JoinRoom)
            {
                JoinRoomInServer(sender, e);
            }

            if (message.Tag == Tags.PlayerJoinedRoom)
            {
                PlayerJoinedActualRoom(sender, e);
            }            
            
            if (message.Tag == Tags.SendAllRooms)
            {
                GetAllRooms(sender, e);
            }
        }
    }

    private void GetAllRooms(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                int roomNumber = reader.ReadInt32();

                for (int i = 0; i < roomNumber; i++)
                {
                    RoomData room = reader.ReadSerializable<RoomData>();
                    rooms.Add(room.ID,room);
                }
            }
        }
    }

    public void JoinRandomRoom()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(true);

            using (Message message = Message.Create(Tags.JoinRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void JoinRoom(ushort roomID)
    {

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(false);
            writer.Write(roomID);

            using (Message message = Message.Create(Tags.JoinRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void JoinRoomInServer(object sender, MessageReceivedEventArgs e)
    {
        // Quand le joueur à recu la réponse de sa requete JOIN ROOM

        mainMenu.SetActive(false);
        roomPanel.SetActive(true);

        ushort roomID;
        List<PlayerData> _playerList = new List<PlayerData>();
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                roomID = reader.ReadUInt16();
                int playerNumber = reader.ReadInt32();

                for (int i = 0; i < playerNumber; i++)
                {

                    PlayerData player = reader.ReadSerializable<PlayerData>();
                    _playerList.Add(player);
                }
            }
        }
        rooms[roomID].playerList = _playerList;

        roomPanelControl.InitRoom(rooms[roomID]);

    }

    private void PlayerJoinedActualRoom(object sender, MessageReceivedEventArgs e)
    {

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                PlayerData player = reader.ReadSerializable<PlayerData>();
                actualRoomIn.playerList.Add(player);
                roomPanelControl.AddPlayer(player);
            }
        }
    }

    public void CreateRoom()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write("TESTROOM");

            using (Message message = Message.Create(Tags.CreateRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }


    private void RoomCreatedInServer(object sender, MessageReceivedEventArgs e)
    {
        ushort hostID;
        RoomData room = new RoomData();

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                room.ID = reader.ReadUInt16();
                room.Name = reader.ReadString();
                hostID = reader.ReadUInt16();

                rooms.Add(room.ID, room);
            }
        }

        if (hostID != client.ID)
        {
            return;
        }

        // SI CREATEUR DE LA ROOM >>

        print("ROOM CREE");

        actualRoomIn = room;

        PlayerData hostPlayerData = new PlayerData(
         hostID,
         true,
         localPlayer.Name,
         0, 0, 0
          );
        actualRoomIn.playerList.Add(hostPlayerData);

        mainMenu.SetActive(false);
        roomPanel.SetActive(true);

        roomPanelControl.InitRoom(actualRoomIn);

    }


    public void DisplayRoomList()
    {
        roomListPanel.SetActive(true);
        roomListPanelControl.Init();
    }

}
