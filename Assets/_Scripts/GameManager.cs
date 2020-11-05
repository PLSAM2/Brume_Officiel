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

    public List<Ward> allWard = new List<Ward>();

    private bool stopInit = false;
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
        remainingTime = timePerRound;
        int secondRemaining = (int)remainingTime % 60;
        int minuteRemaining = (int)Math.Floor(remainingTime / 60);
        UiManager.Instance.timer.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message _message = Message.Create(Tags.PlayerJoinGameScene, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
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

            if (message.Tag == Tags.StartTimer)
            {
                StartTimerInServer();
            }
            if (message.Tag == Tags.StopGame)
            {
                StopGameInServer();
            }            
            if (message.Tag == Tags.AllPlayerJoinGameScene)
            {
                AllPlayerJoinGameScene();
            }

        }
    }

    private void AllPlayerJoinGameScene()
    {
        UiManager.Instance.AllPlayerJoinGameScene();
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
            }
            return;

        }
        int secondRemaining = (int)remainingTime % 60;
        int minuteRemaining = (int)Math.Floor(remainingTime / 60);
        UiManager.Instance.timer.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

    }

    //private void StopGame()
    //{
    //    using (DarkRiftWriter _writer = DarkRiftWriter.Create())
    //    {
    //        _writer.Write(RoomManager.Instance.actualRoom.ID);

    //        using (Message _message = Message.Create(Tags.StopGame, _writer))
    //        {
    //            client.SendMessage(_message, SendMode.Reliable);
    //        }
    //    }
    //}

    private void StopGameInServer()
    {
        RoomManager.Instance.AlreadyInit = true;

        SceneManager.LoadScene(RoomManager.Instance.champSelectScene, LoadSceneMode.Single);
    }

    private void StartTimerInServer()
    {
        timeStart = true;
    }
    
}
