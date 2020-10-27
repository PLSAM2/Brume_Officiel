using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InGameNetworkReceiver : MonoBehaviour
{
    private static InGameNetworkReceiver _instance;
    public static InGameNetworkReceiver Instance { get { return _instance; } }

    UnityClient client;
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

        client = RoomManager.Instance.client;
        client.MessageReceived += OnMessageReceive;
    }

    private void OnDisable()
    {
        client.MessageReceived -= OnMessageReceive;
    }

    private void OnMessageReceive(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.LaunchWard)
            {
                LaunchWardInServer(sender, e);
            }
            if (message.Tag == Tags.StartWardLifeTime)
            {
                StartWardLifeTimeInServer(sender, e);
            }
        }
    }

    private void LaunchWardInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                float xDestination = reader.ReadSingle();
                float yDestination = reader.ReadSingle();
                float zDestination = reader.ReadSingle();

                Vector3 destination = new Vector3(xDestination, yDestination, zDestination);

                GameManager.Instance.networkPlayers[_id].GetComponent<WardModule>().InitWardLaunch(destination);
            }
        }
    }

    private void StartWardLifeTimeInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                GameManager.Instance.networkPlayers[_id].GetComponent<WardModule>().WardLanded();
            }
        }
    }

}
