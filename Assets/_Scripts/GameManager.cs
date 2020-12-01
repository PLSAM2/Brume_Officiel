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
    public List<VisionTower> allTower = new List<VisionTower>();

    public List<Ghost> allGhost = new List<Ghost>();

    public List<BrumeScript> allBrume = new List<BrumeScript>();

    private bool stopInit = false;
    public bool gameStarted = false;

    public Animator globalVolumeAnimator;

    //Event utile
    public Action<ushort, ushort> OnPlayerDie;
    public Action<ushort, bool> OnPlayerAtViewChange;
    public Action<ushort, ushort> OnPlayerGetDamage;
    public Action<ushort> OnPlayerRespawn;

    public Action<Ward> OnWardTeamSpawn;
    public Action<VisionTower> OnTowerTeamCaptured;

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
        NetworkManager.Instance.OnPlayerQuit += PlayerQuitGame;
    }

    private void OnEnable()
    {
        OnPlayerGetDamage += OnPlayerTakeDamage;
    }

    private void OnDisable()
    {
        client.MessageReceived -= OnMessageReceive;
        OnPlayerGetDamage -= OnPlayerTakeDamage;
        NetworkManager.Instance.OnPlayerQuit -= PlayerQuitGame;
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
        }
    }

    public List<SpawnPoint> GetSpawnsOfTeam(Team team)
    {
        return spawns[RoomManager.Instance.assignedSpawn[team]];
    }

    private void PlayerQuitGame(PlayerData Obj)
    {
        if (NetworkManager.Instance.GetLocalPlayer().ID != Obj.ID)
        {
            UiManager.Instance.DisplayGeneralMessage("Player " + Obj.Name + " quit");
        }

        networkPlayers.Remove(Obj.ID);
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

    void OnPlayerTakeDamage(ushort idPlayer, ushort _damage)
    {
        if (GameFactory.CheckIfPlayerIsInView(idPlayer))
        {
            LocalPoolManager.Instance.SpawnNewTextFeedback(GameManager.Instance.networkPlayers[idPlayer].transform.position + Vector3.up * 1.5f, _damage.ToString(), Color.red);
        }
    }

    public void QuitGame()
    {
        if (GameFactory.GetLocalPlayerObj() != null)
        {
            GameFactory.GetLocalPlayerObj().gameObject.SetActive(false);
        }

        RoomManager.Instance.QuitGame();
    }
}
