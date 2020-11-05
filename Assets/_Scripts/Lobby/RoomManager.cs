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
                StartChampSelectInServer(sender, e);
            }
            //if (message.Tag == Tags.QuitGame)
            //{
            //    QuitGameInServer(sender, e);
            //}

            if (message.Tag == Tags.StartGame)
            {
                StartGameInServer(sender, e);
            }
        }
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

    private void StartChampSelectInServer(object sender, MessageReceivedEventArgs e)
    {
        SceneManager.LoadScene(champSelectScene, LoadSceneMode.Single);
    }

    private void StartGameInServer(object sender, MessageReceivedEventArgs e)
    {
        GetLocalPlayer().IsReady = false;
        SceneManager.LoadScene(gameScene, LoadSceneMode.Single);
        StartNewRound();
    }

    private void StartNewRound()
    {
        roundCount++;
    }

    private void ResetActualGame()
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
