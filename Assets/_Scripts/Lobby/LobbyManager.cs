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
using UnityEngine.SceneManagement;

public class LobbyManager : MonoBehaviour
{
    private static LobbyManager _instance;
    public static LobbyManager Instance { get { return _instance; } }

    public RoomPanelControl roomPanelControl;
    public RoomListPanelControl roomListPanelControl;
    public Dictionary<ushort, RoomData> rooms = new Dictionary<ushort, RoomData>();

    private UnityClient client;
    [SerializeField] private InputField nameInputField;
    [SerializeField] private GameObject loginMenu;
    [SerializeField] private GameObject mainMenu;
    [SerializeField] private GameObject roomPanel;
    [SerializeField] private GameObject roomListPanel;
    [SerializeField] private GameObject statMenu;

    [SerializeField] private TextMeshProUGUI pingtest;

    [SerializeField] AudioClip _bgMusic;

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
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.None;
        client = NetworkManager.Instance.GetLocalClient();

        client.MessageReceived += MessageReceived;
        NetworkManager.Instance.OnPlayerQuit += PlayerQuitActualRoom;
        nameInputField.text = NetworkManager.Instance.GetLocalPlayer().Name;

        AudioManager.Instance.SetBackgroundMusic(_bgMusic);

        if (client.ConnectionState == ConnectionState.Connected)
        {
            AskForAllRooms();
        }
    }

    private void OnDisable()
    {
        NetworkManager.Instance.OnPlayerQuit -= PlayerQuitActualRoom;
        client.MessageReceived -= MessageReceived;
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
            if (message.Tag == Tags.StartPrivateRoom)
            {
                InitPrivateRoomInServer(sender, e);
            }
            if (message.Tag == Tags.SetPrivateRoomCharacter)
            {
                SetPrivateRoomCharacterAndStart(sender, e);
            }

        }
    }

    public void AskForAllRooms()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            using (Message message = Message.Create(Tags.SendAllRooms, writer))
                client.SendMessage(message, SendMode.Reliable);
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
                NetworkManager.Instance.GetLocalPlayer().Name = reader.ReadString();
            }
        }
        PlayerPrefs.SetString("PlayerName", NetworkManager.Instance.GetLocalPlayer().Name);
        nameInputField.text = NetworkManager.Instance.GetLocalPlayer().Name;
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
                rooms.Clear();
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


        roomListPanelControl.Init();
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
        roomListPanel.SetActive(false);
        roomPanel.SetActive(true);

        ushort roomID;
        Dictionary<ushort, PlayerData> _playerList = new Dictionary<ushort, PlayerData>();
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                roomID = reader.ReadUInt16();
                NetworkManager.Instance.GetLocalPlayer().playerTeam = (Team)reader.ReadUInt16();
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
        rooms[roomID].playerList[NetworkManager.Instance.GetLocalPlayer().ID] = NetworkManager.Instance.GetLocalPlayer();

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
    private void PlayerQuitActualRoom(PlayerData quittingPlayer)
    {
        if (RoomManager.Instance.actualRoom.playerList.ContainsKey(quittingPlayer.ID))
        {
            RoomManager.Instance.actualRoom.playerList.Remove(quittingPlayer.ID);
        }

        roomPanelControl.RemovePlayer(quittingPlayer);
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
                    NetworkManager.Instance.GetLocalPlayer().playerTeam = (Team)reader.ReadUInt16();
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

        NetworkManager.Instance.GetLocalPlayer().IsHost = true;

        RoomManager.Instance.actualRoom.playerList.Add(NetworkManager.Instance.GetLocalPlayer().ID, NetworkManager.Instance.GetLocalPlayer()); ;

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
        RoomManager.Instance.ResetActualGame();
        NetworkManager.Instance.GetLocalPlayer().IsHost = false;
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
            NetworkManager.Instance.GetLocalPlayer().playerTeam = team;
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
            NetworkManager.Instance.GetLocalPlayer().IsReady = value;
        }
    }

    public void DisplayMainMenu()
    {
        mainMenu.SetActive(true);
        roomPanel.SetActive(false);
        roomListPanel.SetActive(false);
        statMenu.SetActive(false);
    }

    public void DisplayStat()
    {
        mainMenu.SetActive(false);
        statMenu.SetActive(true);
    }

    public void DisplayRoomList()
    {
        roomListPanel.SetActive(true);
        mainMenu.SetActive(false);
        roomPanel.SetActive(false);
        roomListPanelControl.Init();
    }
    public void StartPrivateRoom(bool isTraining)
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(isTraining);
            using (Message message = Message.Create(Tags.StartPrivateRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }


    private void InitPrivateRoomInServer(object sender, MessageReceivedEventArgs e)
    {
        PlayerData player = NetworkManager.Instance.GetLocalPlayer();

        RoomType _temp = RoomType.Training;

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {

                _temp = (RoomType)reader.ReadUInt16();

                RoomData room = new RoomData(reader.ReadUInt16(), reader.ReadString(), true, _temp);

                NetworkManager.Instance.GetLocalPlayer().IsHost = true;

                room.playerList.Add(player.ID, player); ;

                RoomManager.Instance.actualRoom = room;

                player.playerTeam = Team.red;

                RoomManager.Instance.assignedSpawn[Team.red] = 1;
                RoomManager.Instance.assignedSpawn[Team.blue] = 2;
            }
        }

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            if (_temp == RoomType.Training)
            {
                writer.Write((ushort)Character.WuXin);
            } else
            {
                writer.Write((ushort)Character.Re);
            }

            using (Message message = Message.Create(Tags.SetPrivateRoomCharacter, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void SetPrivateRoomCharacterAndStart(object sender, MessageReceivedEventArgs e)
    {
        bool isTraining = true;


        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                isTraining = reader.ReadBoolean();
            }
        }

        PlayerData player = NetworkManager.Instance.GetLocalPlayer();


        if (isTraining)
        {
            Character _character = Character.WuXin;
            player.playerCharacter = _character;

            SceneManager.LoadScene(RoomManager.Instance.loadingTrainingScene);
        }
        else
        {
            Character _character = Character.Re;
            player.playerCharacter = _character;

            SceneManager.LoadScene(RoomManager.Instance.loadingTutorialScene);
        }


    }


    public void QuitGame()
    {
        Application.Quit();
    }


}
