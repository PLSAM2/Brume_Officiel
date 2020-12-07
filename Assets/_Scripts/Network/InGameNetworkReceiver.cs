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
    [SerializeField] GameObject prefabShili;
    [SerializeField] GameObject prefabYang;
    [SerializeField] GameObject prefabYin;

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
            else if (message.Tag == Tags.MovePlayerTag)
            {
                SendPlayerMove(sender, e);
            }
            else if (message.Tag == Tags.SupprObjPlayer)
            {
                SupprPlayerInServer(sender, e);
            }
            else if (message.Tag == Tags.KillCharacter)
            {
                KillCharacterInServer(sender, e);
            }
            else if (message.Tag == Tags.Damages)
            {
                TakeDamagesInServer(sender, e);
            }
            else if (message.Tag == Tags.Heal)
            {
                HealInServer(sender, e);
            }
            else if (message.Tag == Tags.LaunchWard)
            {
                LaunchWardInServer(sender, e);
            }
            else if (message.Tag == Tags.StartWardLifeTime)
            {
                StartWardLifeTimeInServer(sender, e);
            }
            else if (message.Tag == Tags.CurveSpellLaunch)
            {
                CurveSpellLaunchInServer(sender, e);
            }
            else if (message.Tag == Tags.CurveSpellLanded)
            {
                CurveSpellLandedInServer(sender, e);
            }
            else if (message.Tag == Tags.StateUpdate)
            {
                ReceiveState(sender, e);
            }
            else if (message.Tag == Tags.AddForcedMovement)
            {
                ForcedMovementReceived(sender, e);
            }
            else if (message.Tag == Tags.AddStatus)
            {
                ReceiveStatusToAdd(sender, e);
            }
            else if (message.Tag == Tags.AltarTrailDebuff)
            {
                AltarTrailDebuffInServer(sender, e);
            }
            else if (message.Tag == Tags.AltarSpeedBuff)
            {
                AltarSpeedBuffInServer(sender, e);
            }
            else if (message.Tag == Tags.AltarPoisonBuff)
            {
                AltarBuffPoison(sender, e);
            }
            else if (message.Tag == Tags.ChangeFowSize)
            {
                ChangeFowSize(sender, e);
            }
            else if (message.Tag == Tags.SpawnGenericFx)
            {
                OnSpawnGenericFx(sender, e);
            }
            else if (message.Tag == Tags.SpawnAOEFx)
            {
                OnSpawnAOEFx(sender, e);
            }
        }
    }

    private void OnSpawnGenericFx(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _idFx = reader.ReadUInt16();

                float _posX = reader.ReadSingle();
                float _posZ = reader.ReadSingle();

                float _rota = reader.ReadSingle();
                float _scale = reader.ReadSingle();

                float _time = reader.ReadSingle();

                LocalPoolManager.Instance.SpawnNewGenericInLocal(_idFx, new Vector3(_posX, 0, _posZ), _rota, _scale, _time);
            }
        }
    }

    private void OnSpawnAOEFx(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                float _posX = reader.ReadSingle();
                float _posZ = reader.ReadSingle();

                float _rota = reader.ReadSingle();
                float _scale = reader.ReadSingle();

                float _time = reader.ReadSingle();

                LocalPoolManager.Instance.SpawnNewAOELocal(_id, new Vector3(_posX, 0, _posZ), _rota, _scale, _time);
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


    private void CurveSpellLaunchInServer(object sender, MessageReceivedEventArgs e)
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

                GameManager.Instance.networkPlayers[_id].GetComponent<Module_Spit>().InitLaunch(destination);
            }
        }
    }

    private void CurveSpellLandedInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                GameManager.Instance.networkPlayers[_id].GetComponent<Module_Spit>().Landed();
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
                        foreach (SpawnPoint spawn in GameManager.Instance.GetSpawnsOfTeam(RoomManager.Instance.actualRoom.playerList[id].playerTeam))
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


                    GameObject obj = null;

                    switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
                    {
                        case Character.WuXin:
                            obj = Instantiate(prefabShili, spawnPos, Quaternion.identity);
                            break;

                        case Character.Re:
                            obj = Instantiate(prefabYang, spawnPos, Quaternion.identity);
                            break;

                        default:
                            obj = Instantiate(prefabYin, spawnPos, Quaternion.identity);
                            break;
                    }

                    LocalPlayer myLocalPlayer = obj.GetComponent<LocalPlayer>();
                    myLocalPlayer.myPlayerId = id;
                    myLocalPlayer.isOwner = client.ID == id;
                    myLocalPlayer.Init(client);

                 

                    if (myLocalPlayer.isOwner)
                    {
                        GameManager.Instance.currentLocalPlayer = myLocalPlayer;

                        if (isResurecting)
                            myLocalPlayer.myPlayerModule.Setup();

                    }

                    GameManager.Instance.networkPlayers.Add(id, myLocalPlayer);

                    GameManager.Instance.OnPlayerSpawn?.Invoke(id);

                    if (isResurecting)
                    {
                        GameManager.Instance.OnPlayerRespawn?.Invoke(id);
                    }
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

    public void KillCharacter(PlayerData killer = null)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            if(killer != null)
            {
                _writer.Write(killer.ID);
            }
            else {
                _writer.Write(NetworkManager.Instance.GetLocalPlayer().ID);
            }

            _writer.Write((ushort)NetworkManager.Instance.GetLocalPlayer().playerCharacter);
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
                ushort _dealer = reader.ReadUInt16();

                if (!GameManager.Instance.networkPlayers.ContainsKey(_id))
                {
                    return;
                }

                LocalPlayer target = GameManager.Instance.networkPlayers[_id];
                target.DealDamagesLocaly(_damages, _dealer);

                GameManager.Instance.OnPlayerGetDamage?.Invoke(_id, _damages);
            }
        }
    }

    private void HealInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();
                ushort _healValue= reader.ReadUInt16();

                if (!GameManager.Instance.networkPlayers.ContainsKey(_id))
                {
                    return;
                }

                LocalPlayer target = GameManager.Instance.networkPlayers[_id];

                target.liveHealth += _healValue;
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

    public void ReceiveState(object sender, MessageReceivedEventArgs e)
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
                    GameManager.Instance.networkPlayers[id].OnStateReceived(reader.ReadUInt16());
                }
            }
        }
    }

    private void ForcedMovementReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {

                sbyte _newX = reader.ReadSByte();
                sbyte _newZ = reader.ReadSByte();
                ushort _newDuration = reader.ReadUInt16();
                ushort _newStrength = reader.ReadUInt16();
                ushort id = reader.ReadUInt16();

                float _directionX = (float)_newX / 10;
                float _directionZ = (float)_newZ / 10;
                float _duration = (float)_newDuration / 100;
                float _strength = (float)_newStrength / 100;

                ForcedMovement _newForcedMovement = new ForcedMovement();
                _newForcedMovement.direction = new Vector3(_directionX, 0, _directionZ);
                _newForcedMovement.duration = _duration;
                _newForcedMovement.strength = _strength;

                GameManager.Instance.currentLocalPlayer.OnForcedMovementReceived(_newForcedMovement);
            }

        }
    }

    public void ReceiveStatusToAdd(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _roomId = reader.ReadUInt16();
                ushort _statusId = reader.ReadUInt16();
                ushort _playerId = reader.ReadUInt16();

                if(GameManager.Instance.networkPlayers[_playerId] == null) { return; }

                GameManager.Instance.networkPlayers[_playerId].OnAddedStatus(_statusId);
            }
        }
    }

    private void AltarTrailDebuffInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                WxController _temp = (WxController)GameManager.Instance.networkPlayers[_ID].myPlayerModule;
                _temp.ApplyAltarTrailDebuffInServer();
            }

        }
    }


    private void AltarSpeedBuffInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                PlayerModule _temp = GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule;
                _temp.ApplySpeedBuffInServer();
            }
        }
    }

    private void AltarBuffPoison(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                PlayerModule _temp = GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule;
                _temp.ApplyPoisonousBuffInServer();
            }
        }
    }

    private void ChangeFowSize(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _playerId = reader.ReadUInt16();
                uint _size = reader.ReadUInt32();
                bool _reset = reader.ReadBoolean(); 

                if(GameManager.Instance.networkPlayers[_playerId] == null) { return; }

                if (_reset)
                {
                    GameManager.Instance.networkPlayers[_playerId].ResetFowRaduis();
                }
                else
                {
                    GameManager.Instance.networkPlayers[_playerId].SetFowRaduis((float) _size / 100);
                }
            }
        }
    }
}
