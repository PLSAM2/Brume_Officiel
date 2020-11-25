using Cinemachine;
using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.SceneManagement;
using static FieldOfView;
using static GameData;

public class GameManager : SerializedMonoBehaviour
{
    private static GameManager _instance;
    public static GameManager Instance { get { return _instance; } }

    // Spawns >>
    [SerializeField] private Dictionary<ushort, List<SpawnPoint>> spawns = new Dictionary<ushort, List<SpawnPoint>>();
    public List<SpawnPoint> resSpawns = new List<SpawnPoint>();
    // <<

    public Dictionary<ushort, LocalPlayer> networkPlayers = new Dictionary<ushort, LocalPlayer>();
    public Action AllCharacterSpawned;

    [Header("Player")]
    LocalPlayer _currentLocalPlayer;
    public LocalPlayer currentLocalPlayer { get => _currentLocalPlayer; set { _currentLocalPlayer = value; } }

    [SerializeField] UnityClient client;

    LocalPlayer _currentSpecPlayer;

    [Header("Timer")]
    private bool timeStart = false;
    private float timer = 0;

    [Header("Camera")]
    public Camera defaultCam;
    [SerializeField] Animator volumeAnimator;

    public Dictionary<Transform, fowType> visiblePlayer = new Dictionary<Transform, fowType>();

    public List<Ward> allWard = new List<Ward>();

    private bool stopInit = false;
    public bool gameStarted = false;

    public Animator globalVolumeAnimator;

    //Event utile
    public Action<ushort, ushort> OnPlayerDie;
    public Action<ushort, bool> OnPlayerAtViewChange;
    public Action<ushort, ushort> OnPlayerGetDamage;
    public Action<ushort> OnPlayerRespawn;
    public Action<ushort> OnPlayerDisconnect;

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
        timer = 0;
        int secondRemaining = (int)timer % 60;
        int minuteRemaining = (int)Math.Floor(timer / 60);
        UiManager.Instance.timer.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

        RoomManager.Instance.UpdatePointDisplay();
        UiManager.Instance.DisplayGeneralMessage("Round : " + RoomManager.Instance.roundCount);
    }
    public void PlayerJoinedAndInitInScene()
    {

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
            if (message.Tag == Tags.PlayerQuitRoom)
            {
                PlayerQuitGame(_sender, _e);
            }
        }
    }

    public List<SpawnPoint> GetSpawnsOfTeam(Team team)
    {
        return spawns[RoomManager.Instance.assignedSpawn[team]];
    }

    private void PlayerQuitGame(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                PlayerData player = reader.ReadSerializable<PlayerData>();
                UiManager.Instance.DisplayGeneralMessage("Player " + player.Name + " quit");

                OnPlayerDisconnect?.Invoke(player.ID);
            }
        }
    }

    private void AllPlayerJoinGameScene()
    {
        UiManager.Instance.AllPlayerJoinGameScene();
        AllCharacterSpawned?.Invoke();
        gameStarted = true;
    }

    public void ResetCam()
    {
        defaultCam.gameObject.SetActive(true);
        volumeAnimator.SetBool("InBrume", false);
    }

    void UpdateTime()
    {
        timer += Time.deltaTime;

        int secondRemaining = (int)timer % 60;
        int minuteRemaining = (int)Math.Floor(timer / 60);
        UiManager.Instance.timer.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

    }

    private void StopGameInServer()
    {
        RoomManager.Instance.ResetActualGame();
        RoomManager.Instance.StartChampSelectInServer();
    }

    private void StartTimerInServer()
    {
        timeStart = true;
    }

    public LocalPlayer GetFirstPlayerOfOtherTeam()
    {
        ushort? _id = RoomManager.Instance.actualRoom.playerList.Where
            (x => x.Value.playerTeam == GameFactory.GetOtherTeam(RoomManager.Instance.GetLocalPlayer().playerTeam))
            .FirstOrDefault().Key;

        if (_id != null)
        {
            return networkPlayers[(ushort)_id];
        }
        else
        {
            return null;
        }

    }

    public LocalPlayer GetLocalPlayerObj()
    {
        return networkPlayers[RoomManager.Instance.GetLocalPlayer().ID];
    }


}
