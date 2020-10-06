using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DarkRift.Client;
using DarkRift.Client.Unity;
using DarkRift;
using System;

public class LobbyManager : MonoBehaviour
{
    [SerializeField] UnityClient client;

    public RoomData actualRoomIn;
    public List<RoomData> rooms = new List<RoomData>();
    public bool isInRoom = false;

    public GameObject roomPanel;
    public GameObject mainMenu;

    public RoomPanelControl roomPanelControl;

    public void Awake()
    {
        DontDestroyOnLoad(this);

        client.MessageReceived += MessageReceived;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.PlayerConnected)
            {
                if (isInRoom)
                {
                    using (DarkRiftReader reader = message.GetReader())
                    {
                        ushort id = reader.ReadUInt16();
                    }
                }
            }

            if (message.Tag == Tags.CreateRoom)
            {
                RoomCreatedInServer(sender, e);
            }

            if (message.Tag == Tags.JoinRoom)
            {
                JoinRoomInServer(sender, e);
            }

        }
    }

    public void JoinRandomRoom()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(true);

            using (Message message = Message.Create(Tags.JoinRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void JoinRoom(ushort roomID)
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(false);
            writer.Write(roomID);

            using (Message message = Message.Create(Tags.JoinRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void JoinRoomInServer(object sender, MessageReceivedEventArgs e)
    {
        // Quand le joueur à recu la réponse de sa requete JOIN ROOM
        ushort roomID;

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                roomID = reader.ReadUInt16();
            }
        }

    }

    public void CreateRoom()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write("TESTROOM");

            using (Message message = Message.Create(Tags.CreateRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }


    public void RoomCreatedInServer(object sender, MessageReceivedEventArgs e)
    {
        ushort hostID;
        RoomData room = new RoomData();

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                room.ID = reader.ReadUInt16();
                room.Name = reader.ReadString();
                hostID = reader.ReadUInt16();

                rooms.Add(room);
            }
        }

        if (hostID != client.ID)
        {
            return;
        }

        // SI CREATEUR DE LA ROOM >>

        print("ROOM CREE");



        actualRoomIn = room;

        PlayerData hostPlayerData = new PlayerData(
         hostID,
         true,
         "HostTestName"
          );
        actualRoomIn.playerList.Add(hostPlayerData);

        isInRoom = true;

        mainMenu.SetActive(false);
        roomPanel.SetActive(true);

        roomPanelControl.InitRoom(actualRoomIn);

    }

}
