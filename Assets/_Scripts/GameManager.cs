using Cinemachine;
using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.SceneManagement;
using static GameData;

public class GameManager : SerializedMonoBehaviour
{
    private static GameManager _instance;
    public static GameManager Instance { get { return _instance; } }

    public Dictionary<Team, List<SpawnPoint>> spawns = new Dictionary<Team, List<SpawnPoint>>();
    public Dictionary<ushort, LocalPlayer> networkPlayers = new Dictionary<ushort, LocalPlayer>();

    [Header("Player")]
    LocalPlayer _currentLocalPlayer;
    public LocalPlayer currentLocalPlayer {get => _currentLocalPlayer; set { _currentLocalPlayer = value; PlayerSpawned.Invoke(_currentLocalPlayer.myPlayerModule); } }

    [SerializeField] UnityClient client;
    [SerializeField] GameObject prefabPlayer;

    [Header("Timer")]
    [SerializeField] private float timePerRound = 180; // seconds
    private bool timeStart = false;
    private float remainingTime = 0;

    [Header("Camera")]
    public CinemachineVirtualCamera myCam;
    public Camera defaultCam;
    [SerializeField] Animator volumeAnimator;

    public List<Transform> visiblePlayer = new List<Transform>();
    public static Action<PlayerModule> PlayerSpawned;

    private bool stopInit = false;
    private bool isWaitingForRespawn = false;
    private Dictionary<Team, ushort> scores = new Dictionary<Team, ushort>();
   
    public static Action AllCharacterSpawned;
    int numberOfPlayerToSpawn;
    public bool gameStarted = false;

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
        numberOfPlayerToSpawn = RoomManager.Instance.actualRoom.playerList.Count;
        SendSpawnChamp();

        // A refaire >>
        scores.Add(Team.blue, 0);
        scores.Add(Team.red, 0);
        // <<
        remainingTime = timePerRound;
        int secondRemaining = (int)remainingTime % 60;
        int minuteRemaining = (int)Math.Floor(remainingTime / 60);
        UiManager.Instance.timer.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

        if (RoomManager.Instance.GetLocalPlayer().IsHost)
        {
            StartTimer();
        }

    }
    private void Update()
    {
        if (timeStart)
        {
            UpdateTime();
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
                SupprPlayerInServer(_sender, _e);
            }
            if (message.Tag == Tags.StartTimer)
            {
                StartTimerInServer();
            }
            if (message.Tag == Tags.StopGame)
            {
                StopGameInServer();
            }
            if (message.Tag == Tags.AddPoints)
            {
                AddPointsInServer(_sender, _e);
            }
            if (message.Tag == Tags.KillCharacter)
            {
                KillCharacterInServer(_sender, _e);
            }
            if (message.Tag == Tags.Damages)
            {
                TakeDamagesInServer(_sender, _e);
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

                scores[_team] += _score;

                if (_team == RoomManager.Instance.GetLocalPlayer().playerTeam)
                {
                    UiManager.Instance.allyScore.text = scores[_team].ToString();

                    UiManager.Instance.DisplayGeneralPoints(_team, _score);

                } else
                {
                    UiManager.Instance.ennemyScore.text = scores[_team].ToString();
                }
            }


        }
    }

    public void ResetCam()
    {
        defaultCam.gameObject.SetActive(true);
        volumeAnimator.SetBool("InBrume", false);
    }

    void UpdateTime()
    {

        remainingTime -= Time.deltaTime;

        if (remainingTime <= 0)
        {
            if (!stopInit)
            {
                stopInit = true;
                StopGame();
            }
            return;

        }
        int secondRemaining = (int)remainingTime % 60;
        int minuteRemaining = (int)Math.Floor(remainingTime / 60);
        UiManager.Instance.timer.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

    }


    private void StopGame()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message _message = Message.Create(Tags.StopGame, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }


    private void StopGameInServer()
    {
        RoomManager.Instance.AlreadyInit = true;

        SceneManager.LoadScene(RoomManager.Instance.champSelectScene, LoadSceneMode.Single);
    }

    private void StartTimer()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message _message = Message.Create(Tags.StartTimer, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    private void StartTimerInServer()
    {
        timeStart = true;
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

    public void KillCharacter()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
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

                LocalPlayer target = networkPlayers[_id];

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
        Destroy(networkPlayers[ID].gameObject);
        networkPlayers.Remove(ID);
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

                    if (networkPlayers.ContainsKey(id)) { return; }

                    Vector3 spawnPos = Vector3.zero;

                    foreach (SpawnPoint spawn in spawns[RoomManager.Instance.actualRoom.playerList[id].playerTeam])
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
                        currentLocalPlayer = myLocalPlayer;
                    }

                    networkPlayers.Add(id, myLocalPlayer);

                    //CALLBACK TOUS LES JOUEURS SONT APPARUS
                    numberOfPlayerToSpawn -= 1;
                    if (numberOfPlayerToSpawn == 0)
                    {
                        AllCharacterSpawned.Invoke();
                        gameStarted = true;
                    }
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

                    if (!networkPlayers.ContainsKey(id))
                    {
                        return;
                    }

                    networkPlayers[id].SetMovePosition(

                        new Vector3( //Position
                        reader.ReadSingle(),
                        networkPlayers[id].transform.position.y,
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

    //void SendPlayerAnim(object sender, MessageReceivedEventArgs e)
    //{
    //    using (Message message = e.GetMessage())
    //    {
    //        using (DarkRiftReader reader = message.GetReader())
    //        {
    //            if (message.Tag == Tags.SendAnim)
    //            {
    //                ushort id = reader.ReadUInt16();

    //                if (networkPlayers.ContainsKey(id))
    //                {
    //                    networkPlayers[id].SetAnim(
    //                        reader.ReadSingle(),
    //                        reader.ReadSingle()
    //                        );
    //                }

    //            }
    //        }
    //    }
    //}


    IEnumerator WaitForRespawn()
    {
        isWaitingForRespawn = true;
        yield return new WaitForSeconds(currentLocalPlayer.respawnTime);
        SendSpawnChamp();
        isWaitingForRespawn = false;
    }
}
