using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetworkManager : MonoBehaviour
{
   [SerializeField] UnityClient client;

    private static NetworkManager _instance;
    public static NetworkManager Instance { get { return _instance; } }

    private PlayerData localPlayer;
    public Action<PlayerData> OnPlayerQuit; // Devrait surement etre dans RoomManager

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

        InitLocalPlayer();


        client.MessageReceived += OnMessageReceive;
    }


    private void OnDisable()
    {
        client.MessageReceived -= OnMessageReceive;
    }
    private void InitLocalPlayer()
    {
        localPlayer = new PlayerData();
    }
    private void OnMessageReceive(object sender, MessageReceivedEventArgs e)
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
            if (message.Tag == Tags.PlayerQuitRoom)
            {
                PlayerQuitRoom(sender, e);
            }

        }
    }

    private void Ping()
    {
        if (client.ConnectionState != ConnectionState.Connected)
        {
            return;
        }

        using (DarkRiftWriter Writer = DarkRiftWriter.Create())
        {
            using (Message message = Message.Create(Tags.Ping, Writer))
            {
                message.MakePingMessage();
                client.SendMessage(message, SendMode.Reliable);
                NetworkManager.Instance.GetLocalPlayer();

            }
        }
    }

    public PlayerData GetLocalPlayer()
    {
        return localPlayer;
    }

    public void SetLocalPlayer(PlayerData player)
    {
        localPlayer = player;
    }
    public UnityClient GetLocalClient()
    {
        return client;
    }
    private void PlayerQuitRoom(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                PlayerData disconnectedPlayerInfo;
                disconnectedPlayerInfo = reader.ReadSerializable<PlayerData>();
                OnPlayerQuit?.Invoke(disconnectedPlayerInfo);
            }
        }
    }


}
