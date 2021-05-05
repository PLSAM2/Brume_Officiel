using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class TrainingManager : MonoBehaviour
{
    UnityClient client;

    public List<Image> charImageFeedback = new List<Image>();

    public Color pickedCharColor;
    public Color unpickedCharColor;
    private void Awake()
    {
        client = NetworkManager.Instance.GetLocalClient();
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
            if (message.Tag == Tags.SetPrivateRoomCharacter)
            {
                ChangeCharInServ(sender, e);
            }
        }
    }

    public void ChangeChar(int x)
    {
        Character chara;

        switch (x)
        {
            case 0:
                chara = Character.WuXin;
                break;
            case 1:
                chara = Character.Re;
                break;
            case 2:
                chara = Character.Leng;
                break;
            default:
                return;
        }

        if (chara == NetworkManager.Instance.GetLocalPlayer().playerCharacter)
        {
            return;
        }
        NetworkManager.Instance.GetLocalPlayer().playerCharacter = chara;

        for (int i = 0; i < charImageFeedback.Count; i++)
        {
            charImageFeedback[i].color = unpickedCharColor;
        }
        charImageFeedback[x].color = pickedCharColor;


        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)chara);

            using (Message message = Message.Create(Tags.SetCharacter, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void ChangeCharInServ(object sender, MessageReceivedEventArgs e)
    {
        ushort _id = NetworkManager.Instance.GetLocalPlayer().ID;

        InGameNetworkReceiver.Instance.SupprPlayer(_id);
        RoomManager.Instance.SpawnPlayerObj(_id, true);
    }
}
