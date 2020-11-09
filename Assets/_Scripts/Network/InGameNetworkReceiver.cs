using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class InGameNetworkReceiver : MonoBehaviour
{
    private static InGameNetworkReceiver _instance;
    public static InGameNetworkReceiver Instance { get { return _instance; } }

    //Spawn
    [SerializeField] GameObject prefabPlayer;

    // int numberOfPlayerToSpawn;
    // <<

    private bool isWaitingForRespawn = false;
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
    private void Start()
    {
        SendSpawnChamp();

      //  numberOfPlayerToSpawn = RoomManager.Instance.actualRoom.playerList.Count;
    }
    private void OnMessageReceive(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {

            if (message.Tag == Tags.SpawnObjPlayer)
            {
                SpawnPlayerObj(sender, e);
            }
            if (message.Tag == Tags.AddPoints)
            {
                AddPointsInServer(sender, e);
            }
            if (message.Tag == Tags.MovePlayerTag)
            {
                SendPlayerMove(sender, e);
            }
            if (message.Tag == Tags.SupprObjPlayer)
            {
                SupprPlayerInServer(sender, e);
            }
            if (message.Tag == Tags.KillCharacter)
            {
                KillCharacterInServer(sender, e);
            }
            if (message.Tag == Tags.Damages)
            {
                TakeDamagesInServer(sender, e);
            }
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
    void SpawnPlayerObj(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                if (message.Tag == Tags.SpawnObjPlayer)
                {
                    ushort id = reader.ReadUInt16();

                    if (GameManager.Instance.networkPlayers.ContainsKey(id)) { return; }

                    Vector3 spawnPos = Vector3.zero;

                    foreach (SpawnPoint spawn in GameManager.Instance.spawns[RoomManager.Instance.actualRoom.playerList[id].playerTeam])
                    {
                        if (spawn.CanSpawn())
                        {
                            spawnPos = spawn.transform.position;
                        }
                    }

                    GameObject obj = Instantiate(prefabPlayer, spawnPos, Quaternion.identity) as GameObject;
                    LocalPlayer myLocalPlayer = obj.GetComponent<LocalPlayer>();
                    myLocalPlayer.myPlayerId = id;
                    myLocalPlayer.isOwner = client.ID == id;
                    myLocalPlayer.Init(client);


                    if (myLocalPlayer.isOwner)
                    {
                        GameManager.Instance.currentLocalPlayer = myLocalPlayer;
                    }

                    GameManager.Instance.networkPlayers.Add(id, myLocalPlayer);

                    //CALLBACK TOUS LES JOUEURS SONT APPARUS
                    //numberOfPlayerToSpawn -= 1;
                    //if (numberOfPlayerToSpawn == 0)
                    //{
                      //  AllCharacterSpawned.Invoke();
                    //    GameManager.Instance.gameStarted = true;
                    //}
                }
            }
        }
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

                if (_team == RoomManager.Instance.GetLocalPlayer().playerTeam)
                {
                    UiManager.Instance.allyScore.text = RoomManager.Instance.actualRoom.scores[_team].ToString();

                    UiManager.Instance.DisplayGeneralPoints(_team, _score);

                }
                else
                {
                    UiManager.Instance.ennemyScore.text = RoomManager.Instance.actualRoom.scores[_team].ToString();
                }
            }
        }
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

    public void KillCharacter(ushort killerID = 0)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(killerID);
            _writer.Write((ushort)RoomManager.Instance.GetLocalPlayer().playerCharacter);
            using (Message _message = Message.Create(Tags.KillCharacter, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    private void KillCharacterInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort id = reader.ReadUInt16();
                ushort killerId = reader.ReadUInt16();

                if (client.ID == killerId) // Si on à tué un ennemi
                {
                    UiManager.Instance.DisplayGeneralMessage("You slain an ennemy");
                }

                SupprPlayer(id);

                if (RoomManager.Instance.GetLocalPlayer().ID == id)
                {
                    if (!isWaitingForRespawn)
                    {
                        StartCoroutine(WaitForRespawn());
                    }
                }
            }
        }
    }


    private void TakeDamagesInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();
                ushort _damages = reader.ReadUInt16();
                if (!GameManager.Instance.networkPlayers.ContainsKey(_id))
                {
                    return;
                }

                LocalPlayer target = GameManager.Instance.networkPlayers[_id];

                target.liveHealth -= _damages;

            }
        }

    }


    void SupprPlayerInServer(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort id = reader.ReadUInt16();
                SupprPlayer(id);
            }
        }
    }

    void SupprPlayer(ushort ID)
    {
        Destroy(GameManager.Instance.networkPlayers[ID].gameObject);
        GameManager.Instance.networkPlayers.Remove(ID);
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

                    if (!GameManager.Instance.networkPlayers.ContainsKey(id))
                    {
                        return;
                    }

                    GameManager.Instance.networkPlayers[id].SetMovePosition(

                        new Vector3( //Position
                        reader.ReadSingle(),
                        GameManager.Instance.networkPlayers[id].transform.position.y,
                        reader.ReadSingle()),

                        new Vector3( //Rotation
                        0,
                        reader.ReadSingle(),
                        0)
                   );
                }
            }
        }
    }

    public void ReceiveStatus(object sender, MessageReceivedEventArgs e )
	{
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                if (message.Tag == Tags.StateUpdate)
                {
                    ushort id = reader.ReadUInt16();

                    if (!GameManager.Instance.networkPlayers.ContainsKey(id))
                    {
                        return;
                    }

                    GameManager.Instance.networkPlayers[id].OnStatusReceived(reader.ReadUInt16());
                }
            }
        }
    }
    IEnumerator WaitForRespawn()
    {
        isWaitingForRespawn = true;
        yield return new WaitForSeconds(GameManager.Instance.currentLocalPlayer.respawnTime);
        SendSpawnChamp();
        isWaitingForRespawn = false;
    }
}
