using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System.Collections.Generic;
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

    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
    }

    private void Start()
    {

    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
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

        }
    }

    private void NewRoundInServer(object sender, MessageReceivedEventArgs e)
    {
        StartNewRound();
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

    public void UpdatePointDisplay()
    {
        if (UiManager.Instance != null)
        {
            UiManager.Instance.allyScore.text = actualRoom.scores[GetLocalPlayer().playerTeam].ToString();

            switch (GetLocalPlayer().playerTeam)
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

    public void ResetActualGame()
    {
        actualRoom.scores[Team.red] = 0;
        actualRoom.scores[Team.blue] = 0;

        roundCount = 0;
    }

    //public void QuitGame()
    //{
    //    using (DarkRiftWriter writer = DarkRiftWriter.Create())
    //    {
    //        writer.Write(actualRoom.ID);
    //        print("Quit");
    //        using (Message message = Message.Create(Tags.QuitGame, writer))
    //            client.SendMessage(message, SendMode.Reliable);
    //    }

    //    ResetActualGame();
    //}

    //private void QuitGameInServer(object sender, MessageReceivedEventArgs e)
    //{       
    //    SceneManager.LoadScene(menuScene, LoadSceneMode.Single);
    //}


    public void ResetPlayersReadyStates()
    {
        foreach (KeyValuePair<ushort, PlayerData> p in actualRoom.playerList)
        {
            p.Value.IsReady = false;
        }
    }


    public List<PlayerData> GetAllPlayerInActualRoom(bool includeLocalPlayer = true)
    {
        List<PlayerData> _playerList = new List<PlayerData>();

        foreach (KeyValuePair<ushort, PlayerData> player in actualRoom.playerList)
        {
            if (!includeLocalPlayer && player.Key == client.ID)
            {
                continue;
            }

            _playerList.Add(player.Value);
        }

        return _playerList;
    }

    public PlayerData GetLocalPlayer()
    {
        return actualRoom.playerList[client.ID];
    }

}
