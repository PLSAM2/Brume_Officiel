using Cinemachine;
using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamGameManager : MonoBehaviour
{
    private static SamGameManager _instance;
    public static SamGameManager Instance { get { return _instance; } }

    [SerializeField] GameObject prefabPlayer;

    [SerializeField] UnityClient client;

    Dictionary<ushort, SamLocalPlayer> networkPlayers = new Dictionary<ushort, SamLocalPlayer>();


    //Camera
    public CinemachineVirtualCamera myCam;

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

    private void Start()
    {
        SendSpawnChamp();
    }

    void SendSpawnChamp()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);
            _writer.Write(client.ID);

            using (Message _message = Message.Create(Tags.SpawnObjPlayer, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    public bool debug = false;
    private void Update()
    {
        if (debug)
        {
            debug = false;

            foreach(KeyValuePair<ushort, SamLocalPlayer> element in networkPlayers)
            {
                print(element.Key + " " + element.Value);
            }
        }
    }

    void OnMessageReceive(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SpawnObjPlayer)
            {
                SpawnPlayerObj(_sender, _e);
            }

            if (message.Tag == Tags.MovePlayerTag)
            {
                SendPlayerMove(_sender, _e);
            }

            if (message.Tag == Tags.SupprObjPlayer)
            {
                SupprPlayer(_sender, _e);
            }

            if (message.Tag == Tags.SendAnim)
            {
                SendPlayerAnim(_sender, _e);
            }
        }
    }

    void SupprPlayer(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort id = reader.ReadUInt16();
                Destroy(networkPlayers[id].gameObject);
            }
        }
    }

    void SpawnPlayerObj(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                if (message.Tag == Tags.SpawnObjPlayer)
                {
                    ushort id = reader.ReadUInt16();
                    GameObject obj = Instantiate(prefabPlayer, Vector3.zero, Quaternion.identity) as GameObject;
                    SamLocalPlayer myLocalPlayer = obj.GetComponent<SamLocalPlayer>();
                    myLocalPlayer.myPlayerId = id;
                    myLocalPlayer.isOwer = client.ID == id;
                    myLocalPlayer.Init(client);

                    networkPlayers.Add(id, myLocalPlayer);
                }
            }
        }
    }

    void SendPlayerMove(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                if (message.Tag == Tags.MovePlayerTag)
                {
                    ushort id = reader.ReadUInt16();
                    networkPlayers[id].SetMovePosition(

                        new Vector3( //Position
                        reader.ReadSingle(), 
                        networkPlayers[id].transform.position.y, 
                        reader.ReadSingle()), 
                        
                        new Vector3( //Rotation
                        reader.ReadSingle(),
                        reader.ReadSingle(),
                        reader.ReadSingle())
                        );
                }
            }
        }
    }

    void SendPlayerAnim(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                if (message.Tag == Tags.SendAnim)
                {
                    ushort id = reader.ReadUInt16();
                    networkPlayers[id].SetAnim(
                        reader.ReadSingle(),
                        reader.ReadSingle()
                        );
                }
            }
        }
    }
}
