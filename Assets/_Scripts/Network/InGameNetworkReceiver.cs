﻿using DarkRift;
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

                print(_id);
                print(GameManager.Instance.networkPlayers[_id].myPlayerId);
                print(GameManager.Instance.networkPlayers[_id].GetComponent<WardModule>().isUsed);
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
                    bool isResurecting = reader.ReadBoolean();

                    if (GameManager.Instance.networkPlayers.ContainsKey(id)) { return; }

                    Vector3 spawnPos = Vector3.zero;

                    if (!isResurecting)
                    {
                        foreach (SpawnPoint spawn in GameManager.Instance.spawns[RoomManager.Instance.actualRoom.playerList[id].playerTeam])
                        {
                            if (spawn.CanSpawn())
                            {
                                spawnPos = spawn.transform.position;
                            }
                        }
                    }
                    else
                    {
                        foreach (SpawnPoint spawn in GameManager.Instance.resSpawns)
                        {
                            if (spawn.CanSpawn())
                            {
                                spawnPos = spawn.transform.position;
                            }
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

                    GameManager.Instance.OnPlayerRespawn?.Invoke(id);
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

                SupprPlayer(id);

                GameManager.Instance.OnPlayerDie?.Invoke(id, killerId);

                //if (RoomManager.Instance.GetLocalPlayer().ID == id)
                //{
                //    if (!isWaitingForRespawn)
                //    {
                //        StartCoroutine(WaitForRespawn());
                //    }
                //}
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

                GameManager.Instance.OnPlayerGetDamage?.Invoke(_id, _damages);
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
        if (GameManager.Instance.networkPlayers.ContainsKey(ID))
        {
            Destroy(GameManager.Instance.networkPlayers[ID].gameObject);
            GameManager.Instance.networkPlayers.Remove(ID);
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

    public void ReceiveStatus(object sender, MessageReceivedEventArgs e)
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
    //IEnumerator WaitForRespawn()
    //{
    //    isWaitingForRespawn = true;
    //    yield return new WaitForSeconds(GameManager.Instance.currentLocalPlayer.respawnTime);
    //    SendSpawnChamp();
    //    isWaitingForRespawn = false;
    //}
}
