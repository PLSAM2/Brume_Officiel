using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

public class RoomManager : MonoBehaviour
{
    private static RoomManager _instance;
    public static RoomManager Instance { get { return _instance; } }

    public string gameScene;
    public string menuScene;

    [HideInInspector] public RoomData actualRoom;

    [SerializeField] UnityClient client;


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

        DontDestroyOnLoad(this.gameObject);

        client.MessageReceived += MessageReceived;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.StartGame)
            {
                StartGameInServer(sender, e);
            }
            if (message.Tag == Tags.QuitGame)
            {
                QuitGameInServer(sender, e);
            }
        }
    }

    public void StartGame()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(actualRoom.ID);

            using (Message message = Message.Create(Tags.StartGame, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void StartGameInServer(object sender, MessageReceivedEventArgs e)
    {
        SceneManager.LoadScene(gameScene, LoadSceneMode.Single);
    }

    public void QuitGame()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(actualRoom.ID);
            print("Quit");
            using (Message message = Message.Create(Tags.QuitGame, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void QuitGameInServer(object sender, MessageReceivedEventArgs e)
    {
        SceneManager.LoadScene(menuScene, LoadSceneMode.Single);
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
