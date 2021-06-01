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

    private static TrainingManager _instance;
    public static TrainingManager Instance { get { return _instance; } }

    UnityClient client;
    public GameObject canvas;
    public List<Image> charImageFeedback = new List<Image>();

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
            charImageFeedback[i].gameObject.SetActive(false);
        }

        charImageFeedback[x].gameObject.SetActive(true);


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


        PlayerPrefs.SetInt("SoulSpell", (int)En_SoulSpell.Ward);
        GameManager.Instance.currentLocalPlayer.myPlayerModule.InitSoulSpell(En_SoulSpell.Ward);
        RoomManager.Instance.SpawnPlayerObj(_id, true);
    }
}
