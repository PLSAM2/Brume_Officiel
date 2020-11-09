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

        client.MessageReceived += OnMessageReceive;
    }

    private void OnDisable()
    {
        client.MessageReceived -= OnMessageReceive;
    }

    private void OnMessageReceive(object sender, MessageReceivedEventArgs e)
    {
        // ON MESSAGE RECEIVE
    }

    private void FixedUpdate()
    {
        Ping();
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
            }
        }
    }

}
