﻿using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
using static GameData;

public class RoomManager : MonoBehaviour
{
    private static RoomManager _instance;
    public static RoomManager Instance { get { return _instance; } }

    public string gameScene;
    public string champSelectScene;
    public string menuScene;

    public RoomData actualRoom;

    public UnityClient client;
    public bool AlreadyInit = false;

    [Header("ActualGameInfo")]
    public int roundCount = 0;
    public Dictionary<ushort, ushort> InGameUniqueIDList = new Dictionary<ushort, ushort>();
    [HideInInspector] public Dictionary<Team, ushort> assignedSpawn = new Dictionary<Team, ushort>();

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

        client.MessageReceived += MessageReceived;
    }



    private void Start()
    {
        NetworkManager.Instance.OnPlayerQuit += OnPlayerQuitGame;

        assignedSpawn.Add(Team.red, 0);
        assignedSpawn.Add(Team.blue, 0);
    }

    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
        NetworkManager.Instance.OnPlayerQuit -= OnPlayerQuitGame;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SwapHostRoom)
            {
                SwapHost(sender, e);
            }
            if (message.Tag == Tags.LobbyStartGame)
            {
                StartChampSelectInServer();
            }
            if (message.Tag == Tags.StartGame)
            {
                StartGameInServer(sender, e);
            }
            if (message.Tag == Tags.AddPoints)
            {
                AddPointsInServer(sender, e);
            }
            if (message.Tag == Tags.NewRound)
            {
                NewRoundInServer(sender, e);
            }
            if (message.Tag == Tags.SetInGameUniqueID)
            {
                SetInGameUniqueIDInServer(sender, e);
            }            
            if (message.Tag == Tags.QuitRoom)
            {
                QuitGameInServer();
            }
        }
    }

    private void NewRoundInServer(object sender, MessageReceivedEventArgs e)
    {
        StartNewRound();

        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort redTeamAssignement = reader.ReadUInt16();
                ushort blueTeamAssignement = reader.ReadUInt16();

                assignedSpawn[Team.red] = redTeamAssignement;
                assignedSpawn[Team.blue] = blueTeamAssignement;
            }
        }

        SceneManager.LoadScene(gameScene, LoadSceneMode.Single);
    }

    public void StartChampSelect()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(actualRoom.ID);

            using (Message message = Message.Create(Tags.LobbyStartGame, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void StartChampSelectInServer()
    {
        AlreadyInit = true;
        StartNewRound();
        ResetPlayersReadyStates();
        SceneManager.LoadScene(champSelectScene, LoadSceneMode.Single);
    }

    private void StartGameInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                assignedSpawn[Team.red] = reader.ReadUInt16();
                assignedSpawn[Team.blue] = reader.ReadUInt16();
            }
        }

        SceneManager.LoadScene(gameScene, LoadSceneMode.Single);
    }

    private void StartNewRound()
    {
        roundCount++;
    }
    public void AddPoints(Team targetTeam, ushort value)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write((ushort)targetTeam);
            _writer.Write(value);

            using (Message _message = Message.Create(Tags.AddPoints, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }
    private void AddPointsInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                Team _team = (Team)reader.ReadUInt16();
                ushort _score = reader.ReadUInt16();

                RoomManager.Instance.actualRoom.scores[_team] += _score;
                UpdatePointDisplay();
            }
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

                if (LobbyManager.Instance != null)
                {
                    LobbyManager.Instance.roomPanelControl.SetHost(player, true);
                }

                if (NetworkManager.Instance.GetLocalPlayer().ID == player.ID)
                {
                    NetworkManager.Instance.GetLocalPlayer().IsHost = true;
                    NetworkManager.Instance.GetLocalPlayer().IsHost = true;
                }
            }
        }

    }

    public void UpdatePointDisplay()
    {
        if (UiManager.Instance != null)
        {
            UiManager.Instance.allyScore.text = actualRoom.scores[NetworkManager.Instance.GetLocalPlayer().playerTeam].ToString();

            switch (NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                case Team.red:
                    UiManager.Instance.ennemyScore.text = RoomManager.Instance.actualRoom.scores[Team.blue].ToString();
                    break;
                case Team.blue:
                    UiManager.Instance.ennemyScore.text = RoomManager.Instance.actualRoom.scores[Team.red].ToString();
                    break;
                default:
                    throw new System.Exception("ERREUR equipe non existante");
            }
        }
    }

    private void SetInGameUniqueIDInServer(object sender, MessageReceivedEventArgs e)
    {
        InGameUniqueIDList.Clear();

        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort temp = 0;
                ushort[] _IDs = reader.ReadUInt16s();

                foreach (ushort id in _IDs)
                {
                    temp++;
                    InGameUniqueIDList.Add(id, temp);
                }
            }
        }
    }

    public ushort GetLocalPlayerUniqueID()
    {
        return InGameUniqueIDList[NetworkManager.Instance.GetLocalPlayer().ID];
    }

    public void ResetActualGame()
    {
        actualRoom.scores[Team.red] = 0;
        actualRoom.scores[Team.blue] = 0;

        roundCount = 0;

        foreach (PlayerData p in actualRoom.playerList.Values)
        {
            p.playerCharacter = Character.none;
        }
    }

    public void ResetPlayersReadyStates()
    {
        foreach (KeyValuePair<ushort, PlayerData> p in actualRoom.playerList)
        {
            p.Value.IsReady = false;
        }
    }

    public PlayerData GetPlayerData(ushort id)
    {
        return actualRoom.playerList[id];
    }

    private void OnPlayerQuitGame(PlayerData obj)
    {
        InGameUniqueIDList.Remove(obj.ID);
        actualRoom.playerList.Remove(obj.ID);
    }

    public void QuitGame()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message message = Message.Create(Tags.QuitRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }


    public void QuitGameInServer()
    {
        if (SceneManager.GetActiveScene().name == menuScene)
        {
            return;
        }

        NetworkManager.Instance.GetLocalPlayer().ResetGameData();
        SceneManager.LoadScene(menuScene, LoadSceneMode.Single);
        ResetActualGame();
    }
}
