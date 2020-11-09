using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DarkRift.Client;
using DarkRift.Client.Unity;
using DarkRift;
using System;
using UnityEngine.UI;
using TMPro;
using static GameData;
using Sirenix.OdinInspector;

public class LobbyManager : MonoBehaviour
{
    private static LobbyManager _instance;
    public static LobbyManager Instance { get { return _instance; } }

    public RoomPanelControl roomPanelControl;
    public RoomListPanelControl roomListPanelControl;
    public Dictionary<ushort, RoomData> rooms = new Dictionary<ushort, RoomData>();

    [ReadOnly] public PlayerData localPlayer;

    [SerializeField] UnityClient client;
    [SerializeField] private TMP_InputField nameInputField;
    [SerializeField] private GameObject loginMenu;
    [SerializeField] private GameObject mainMenu;
    [SerializeField] private GameObject roomPanel;
    [SerializeField] private GameObject roomListPanel;

    [SerializeField] private TextMeshProUGUI pingtest;

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

        //if (RoomManager.Instance.AlreadyInit)
        //{
        //    client = RoomManager.Instance.client;

        //    mainMenu.SetActive(false);
        //    loginMenu.SetActive(false);
        //    roomPanel.SetActive(true);

        //    roomPanelControl.InitRoom(RoomManager.Instance.actualRoom);
        //}

        client.MessageReceived += MessageReceived;


    }
    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
    }

    private void Start()
    {
        nameInputField.text = localPlayer.Name;
    }

    private void FixedUpdate()
    {
        if (client.ConnectionState != ConnectionState.Connected)
        {
            return;
        }

        pingtest.text = client.Client.RoundTripTime.LatestRtt.ToString();
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
            if (message.Tag == Tags.DeleteRoom)
            {
                RoomDeletedInServer(sender, e);
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

            if (message.Tag == Tags.QuitRoom)
            {
                QuitActualRoomInServer(sender, e);
            }

            if (message.Tag == Tags.SwapHostRoom)
            {
                SwapHost(sender, e);
            }

            if (message.Tag == Tags.PlayerQuitRoom)
            {
                PlayerQuitActualRoom(sender, e);
            }
            if (message.Tag == Tags.ChangeName)
            {
                ChangeNameInServer(sender, e);
            }
            if (message.Tag == Tags.ChangeTeam)
            {
                ChangeTeamInServer(sender, e);
            }
            if (message.Tag == Tags.SetReady)
            {
                SetReadyInServer(sender, e);
            }

        }
    }


    public void ChangeName()
    {
        string name = nameInputField.text;
        CheckName(ref name);

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(name);

            using (Message message = Message.Create(Tags.ChangeName, writer))
                client.SendMessage(message, SendMode.Reliable);
        }


    }

    public void ChangeName(string name) // Login
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(name);

            using (Message message = Message.Create(Tags.ChangeName, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void CheckName(ref string name)
    {
        if (name.Trim(' ') == "")
        {
            name = "Player" + UnityEngine.Random.Range(0, 1000);
        }
    }

    private void ChangeNameInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                localPlayer.Name = reader.ReadString();
            }
        }
        PlayerPrefs.SetString("PlayerName", localPlayer.Name);
        nameInputField.text = localPlayer.Name;
    }



    private void RoomDeletedInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort roomID = reader.ReadUInt16();
                rooms.Remove(roomID);

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

                    if (!room.IsStarted)
                    {
                        rooms.Add(room.ID, room);
                    }

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

    private void SwapHost(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort playerID = reader.ReadUInt16();

                PlayerData player = RoomManager.Instance.actualRoom.playerList[playerID];

                roomPanelControl.SetHost(player, true);

                if (localPlayer.ID == player.ID)
                {
                    localPlayer.IsHost = true;
                }
            }
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
        roomListPanel.SetActive(false);
        roomPanel.SetActive(true);

        ushort roomID;
        Dictionary<ushort, PlayerData> _playerList = new Dictionary<ushort, PlayerData>();
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                roomID = reader.ReadUInt16();
                localPlayer.playerTeam = (Team)reader.ReadUInt16();
                int playerNumber = reader.ReadInt32();

                for (int i = 0; i < playerNumber; i++)
                {
                    PlayerData player = reader.ReadSerializable<PlayerData>();
                    _playerList.Add(player.ID, player);
                }
            }
        }

        RoomManager.Instance.actualRoom = rooms[roomID];
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
                RoomManager.Instance.actualRoom.playerList.Add(player.ID, player);

                roomPanelControl.AddPlayer(player);
            }
        }
    }

    private void PlayerQuitActualRoom(object sender, MessageReceivedEventArgs e)
    {

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                PlayerData player = reader.ReadSerializable<PlayerData>();
                roomPanelControl.RemovePlayer(RoomManager.Instance.actualRoom.playerList[player.ID]);
                RoomManager.Instance.actualRoom.playerList.Remove(player.ID);
            }
        }
    }

    public void CreateRoom()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
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
                room = reader.ReadSerializable<RoomData>();
                hostID = reader.ReadUInt16();

                if (hostID == client.ID)
                {
                    localPlayer.playerTeam = (Team)reader.ReadUInt16();
                }

                rooms.Add(room.ID, room);
            }
        }

        if (hostID != client.ID)
        {
            return;
        }

        // SI CREATEUR DE LA ROOM >>

        RoomManager.Instance.actualRoom = room;

        localPlayer.IsHost = true;

        RoomManager.Instance.actualRoom.playerList.Add(localPlayer.ID, localPlayer); ;

        mainMenu.SetActive(false);
        roomPanel.SetActive(true);

        roomPanelControl.InitRoom(RoomManager.Instance.actualRoom);

    }

    public void QuitActualRoom()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message message = Message.Create(Tags.QuitRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void QuitActualRoomInServer(object sender, MessageReceivedEventArgs e)
    {
        print("Room " + RoomManager.Instance.actualRoom.ID + " Quit");
        RoomManager.Instance.actualRoom = null;
        localPlayer.IsHost = false;
        DisplayMainMenu();
    }

    public void ChangeTeam(Team team)
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)team);

            using (Message message = Message.Create(Tags.ChangeTeam, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void ChangeTeamInServer(object sender, MessageReceivedEventArgs e)
    {
        ushort playerID;
        Team team;
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                playerID = reader.ReadUInt16();
                team = (Team)reader.ReadUInt16();

                RoomManager.Instance.actualRoom.playerList[playerID].playerTeam = team;
                roomPanelControl.ChangeTeam(playerID, team);
            }
        }

        if (playerID == client.ID)
        {
            localPlayer.playerTeam = team;
        }
    }

    public void SetReady(bool value)
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(value);

            using (Message message = Message.Create(Tags.SetReady, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void SetReadyInServer(object sender, MessageReceivedEventArgs e)
    {
        ushort playerID;
        bool value = false;

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                playerID = reader.ReadUInt16();
                value = reader.ReadBoolean();

                RoomManager.Instance.actualRoom.playerList[playerID].IsReady = value;
                roomPanelControl.SetReady(playerID, value);
            }
        }

        if (playerID == client.ID)
        {
            localPlayer.IsReady = value;
        }
    }

    public void DisplayMainMenu()
    {
        mainMenu.SetActive(true);
        roomPanel.SetActive(false);
        roomListPanel.SetActive(false);
    }

    public void DisplayRoomList()
    {
        roomListPanel.SetActive(true);
        mainMenu.SetActive(false);
        roomPanel.SetActive(false);
        roomListPanelControl.Init();
    }

}
