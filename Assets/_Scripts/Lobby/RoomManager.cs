using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
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
    public Dictionary<ushort, ushort> ultimateStack = new Dictionary<ushort, ushort>();
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
            if (message.Tag == Tags.StopGame)
            {
                StopGameInServer(sender, e);
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
        Team winningTeam = Team.none;
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                winningTeam = (Team)reader.ReadUInt16();
                ushort redTeamAssignement = reader.ReadUInt16();
                ushort blueTeamAssignement = reader.ReadUInt16();

                assignedSpawn[Team.red] = redTeamAssignement;
                assignedSpawn[Team.blue] = blueTeamAssignement;
            }
        }

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == winningTeam)
        {
            UiManager.Instance.EndGamePanel(true, 0, winningTeam);
        }
        else
        {
            UiManager.Instance.EndGamePanel(false, 0, winningTeam);
        }

        InGameNetworkReceiver.Instance.SetEndGame(true);

        StartCoroutine(EndGame(true, gameScene));
    }

    IEnumerator EndGame(bool isNewRound = false, string sceneName = "")
    {
        Time.timeScale = Time.timeScale / 4;

        yield return new WaitForSeconds(1);

        Time.timeScale = 1;

        if (isNewRound)
        {
            SceneManager.LoadScene(sceneName, LoadSceneMode.Single);
        }
        else
        {
            ResetActualGame();
            StartChampSelectInServer();
        }

    }

    private void StopGameInServer(object sender, MessageReceivedEventArgs e)
    {
        Team winningTeam = Team.none;

        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                winningTeam = (Team)reader.ReadUInt16();
            }
        }

        if (winningTeam == Team.none)
        {
            ResetActualGame();
            StartChampSelectInServer();
            return;
        }

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == winningTeam)
        {
            UiManager.Instance.EndGamePanel(true, 1, winningTeam);
        }
        else
        {
            UiManager.Instance.EndGamePanel(false, 1, winningTeam);
        }

        InGameNetworkReceiver.Instance.SetEndGame(true);

        StartCoroutine(EndGame(false));

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

        foreach (KeyValuePair<ushort, PlayerData> item in actualRoom.playerList.Where
            (x => x.Value.playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam))
        {
            ultimateStack.Add(item.Key, 0);
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
        ultimateStack.Clear();

        if (actualRoom != null && actualRoom.scores.ContainsKey(Team.red))
        {
            actualRoom.scores[Team.red] = 0;
            actualRoom.scores[Team.blue] = 0;

            foreach (PlayerData p in actualRoom.playerList.Values)
            {
                p.playerCharacter = Character.none;
            }
        }

        roundCount = 0;
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

    internal void TryAddUltimateStacks(ushort playerId, ushort value, bool set = false)
    {
        if (NetworkManager.Instance.GetLocalPlayer() == null) { return; }

        if (actualRoom.playerList[playerId].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            if (set)
            {
                ultimateStack[playerId] = value;
            }
            else
            {
                ultimateStack[playerId] += value;
            }

            UiManager.Instance.SetUltimateStacks(playerId, ultimateStack[playerId]);
        }
    }

    internal void TryUseUltStacks(ushort stacksUsed)
    {
        ushort pId = NetworkManager.Instance.GetLocalPlayer().ID;
        if (!GameManager.Instance.networkPlayers.ContainsKey(pId)) { return; }

        if (ultimateStack[pId] >= stacksUsed)
        {
            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(stacksUsed);

                using (Message _message = Message.Create(Tags.UseUltPoint, _writer))
                {
                    client.SendMessage(_message, SendMode.Reliable);
                }
            }
        }

    }

    internal ushort GetPlayerUltStacks(ushort id)
    {
        if (!GameManager.Instance.networkPlayers.ContainsKey(id)) { return 0; }
        if (actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return ultimateStack[id];
        }

        return 0;
    }
}
