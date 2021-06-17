using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;
using static FieldOfView;
using static GameData;
using DG.Tweening;
using System.Collections;

public class GameManager : SerializedMonoBehaviour
{
    private static GameManager _instance;
    public static GameManager Instance { get { return _instance; } }

    // Spawns >>
    [SerializeField] private Dictionary<ushort, List<SpawnPoint>> spawns = new Dictionary<ushort, List<SpawnPoint>>();
    [SerializeField] public Dictionary<Team, List<SpawnPoint>> trainSpawns = new Dictionary<Team, List<SpawnPoint>>();
    // <<

    public Dictionary<ushort, LocalPlayer> networkPlayers = new Dictionary<ushort, LocalPlayer>();

    [Header("Player")]
    LocalPlayer _currentLocalPlayer;
    public LocalPlayer currentLocalPlayer { get => _currentLocalPlayer; set { _currentLocalPlayer = value; } }
    [SerializeField] UnityClient client;

    [Header("Timer")]
    private bool timeStart = false;
    private bool endZoneStarted = false;
    private bool isReviving = false;
    public float timer = 0;
    public float endZoneTimer = 61;
    public float trainTimer = 40;
    public bool trainTimerStarted = false;
    public float baseReviveTime = 15;
    private float reviveTimer = 0;

    private float overtime = 3;
    private float baseOvertime = 3;
    [Header("Camera")]
    public Camera defaultCam;
    public Material[] materialNeedingTheCamPos;
    public Transform offSetCam;

    public Dictionary<Transform, fowType> visiblePlayer = new Dictionary<Transform, fowType>();

    public List<Ward> allWard = new List<Ward>();
    public List<VisionTower> allTower = new List<VisionTower>();
    public List<Altar> allAltar = new List<Altar>();

    public List<Brume> allBrume = new List<Brume>();

    public List<Fx> allFx = new List<Fx>();
    public List<Transform> allVisibleFx = new List<Transform>();

    public List<ushort> allVisibleInteractible = new List<ushort>();

    public bool gameStarted = false;

    public Animator globalVolumeAnimator;

    public LayerMask brumeLayer;

    public GameObject brumeSoul;
    public Dictionary<ushort, BrumeSoul> brumeSouls = new Dictionary<ushort, BrumeSoul>();

    [HideInInspector] public bool playerJoinedAndInit = false; //spawnpurpose
    public List<LocalPlayer> allEnemies = new List<LocalPlayer>();

    //Event utile
    [HideInInspector] public Action<ushort, ushort> OnPlayerDie;
    [HideInInspector] public Action<ushort> OnSpecConnected;
    [HideInInspector] public Action<ushort, bool> OnPlayerAtViewChange;
    [HideInInspector] public Action<ushort, ushort, ushort> OnPlayerGetDamage;
    [HideInInspector] public Action<ushort, ushort> OnPlayerGetHealed;
    [HideInInspector] public Action<ushort> OnPlayerRespawn;
    [HideInInspector] public Action<ushort> OnPlayerSpawn;
    [HideInInspector] public Action OnAllCharacterSpawned;
    [HideInInspector] public Action<bool> OnLocalPlayerStateBrume;
    [HideInInspector] public Action OnRoundFinish;
    [HideInInspector] public Action OnGameFinish;

    [HideInInspector] public Action<Ward> OnWardTeamSpawn;
    [HideInInspector] public Action<VisionTower> OnTowerTeamCaptured;

    [HideInInspector] public Action<ushort, bool> OnInteractibleViewChange;
    public int numberOfAltarControled, numberOfAltarControledByEnemy = 0;

    public GameObject deadPostProcess;

    [HideInInspector] public bool menuOpen = false;
    [HideInInspector] public bool blockMovement = false;

    [Header("Shader")]
    public List<Material> shaderDifMaterial = new List<Material>();
    public string property = "_Out_or_InBrume";

    public AudioClip bgMusic, timerTrain, timerTrainSpawn;
    public Dictionary<Character, AudioClip> deathSounds = new Dictionary<Character, AudioClip>();
    private bool reviveFeedbackSet = false;
    //debug
    public CanvasGroup UIGroup;

    public Material _mistMat;

    [HideInInspector]
    public bool haveChoiceSoulSpell = false;

    public Sc_CharacterParameters wxParameter;
    public Sc_CharacterParameters reParameter;
    public Sc_CharacterParameters lengParameter;

    public GameObject freeCam;

    public GameObject fowDebug;

    public Volume damageVolume;

    public bool doFow = false;

    public GameObject statCamera;

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
        numberOfAltarControled = 0;
        numberOfAltarControledByEnemy = 0;

        client = RoomManager.Instance.client;
        client.MessageReceived += OnMessageReceive;
        NetworkManager.Instance.OnPlayerQuit += PlayerQuitGame;
    }

    private void OnEnable()
    {
        OnPlayerDie += OnAPlayerDie;
        OnPlayerRespawn += OnPlayerRespawnId;
    }

    private void OnAPlayerDie(ushort killed, ushort killer)
    {
        if (NetworkManager.Instance.GetLocalPlayer().ID == killed && NetworkManager.Instance.GetLocalPlayer().playerCharacter == Character.WuXin)
        {
            StartCoroutine(PlayDeathSoundLater());
        }
    }

    IEnumerator PlayDeathSoundLater()
    {
        yield return new WaitForSeconds(1);

        AudioManager.Instance.Play2DCharacterAudio(deathSounds[NetworkManager.Instance.GetLocalPlayer().playerCharacter]);
    }

    private void OnDisable()
    {
        OnPlayerRespawn -= OnPlayerRespawnId;

        client.MessageReceived -= OnMessageReceive;

        NetworkManager.Instance.OnPlayerQuit -= PlayerQuitGame;

        foreach (Material _mat in materialNeedingTheCamPos)
            _mat.SetVector("_Object_Position", new Vector4(0, 0, 0, 1));

        foreach (Material mat in GameManager.Instance.shaderDifMaterial)
        {
            mat.SetFloat(GameManager.Instance.property, 0);
        }
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.Confined;
        timer = 0;
        baseOvertime = overtime;

        SetTimer(timer, UiManager.Instance.timer);

        // SetTimer(endZoneTimer,UiManager.Instance.endZoneTimer.timer);

        RoomManager.Instance.UpdatePointDisplay();
        UiManager.Instance.chat.DisplayMessage("Round : " + RoomManager.Instance.roundCount);

        AudioManager.Instance.SetBackgroundMusic(bgMusic);

        if (RoomManager.Instance.roundCount == 1)
        {
            trainTimerStarted = true;
            UiManager.Instance.trainPanel.SetActive(true);
        }


        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
        {
            GameManager.Instance.playerJoinedAndInit = true;
            GameManager.Instance.PlayerJoinedAndInitInScene();
        }
    }

    public void PlayerJoinedAndInitInScene()
    {
        RoomManager.Instance.SpawnDelayedPlayer();
    }

    void OnPlayerRespawnId(ushort _id)
    {
        if (_id == NetworkManager.Instance.GetLocalClient().ID)
        {
            En_SoulSpell _mySoulSpell = (En_SoulSpell)PlayerPrefs.GetInt("SoulSpell");
            _currentLocalPlayer.myPlayerModule.InitSoulSpell(_mySoulSpell);
        }
    }

    private void Update()
    {
        if (timeStart)
        {
            UpdateTime();
        }

        foreach (Material _mat in materialNeedingTheCamPos)
            _mat.SetVector("_Object_Position", new Vector4(offSetCam.position.x, offSetCam.position.y, offSetCam.position.z, 1));

        //debug
        if (Input.GetKeyDown(KeyCode.U) && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
        {
            UIGroup.alpha = (UIGroup.alpha == 0) ? 1 : 0;
        }

        //debug
        if (Input.GetKeyDown(KeyCode.M) && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
        {
            UIGroup.alpha = (UIGroup.alpha == 0) ? 1 : 0;
            freeCam.SetActive(!freeCam.activeSelf);
            blockMovement = !blockMovement;

            fowDebug.SetActive(freeCam.activeSelf);
        }

        //DamageEffect
        LocalPlayer currentLocalPlayer = GameFactory.GetActualPlayerFollow();
        if (currentLocalPlayer != null)
        {
            switch (currentLocalPlayer.liveHealth)
            {
                case 1:
                    damageVolume.weight = 1;
                    break;

                case 2:
                    damageVolume.weight = 0.5f;
                    break;

                default:
                    damageVolume.weight = 0;
                    break;
            }
        }
        else
        {
            damageVolume.weight = 0;
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

    private void PlayerQuitGame(PlayerData p)
    {
        if (NetworkManager.Instance.GetLocalPlayer().ID != p.ID)
        {
            UiManager.Instance.chat.DisplayMessage(GameFactory.GetNameAddChamp(p) + " left the game");

            if (networkPlayers.ContainsKey(p.ID) && networkPlayers[p.ID] != null)
            {
                Destroy(networkPlayers[p.ID].gameObject);
            }
        }

        networkPlayers.Remove(p.ID);
    }

    private void AllPlayerJoinGameScene()
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator) // IF spectator
        {
            UiManager.Instance.SpecJoinGameScene();
            OnSpecConnected?.Invoke(NetworkManager.Instance.GetLocalPlayer().ID);
            OnAllCharacterSpawned?.Invoke();
            gameStarted = true;
            return;
        }



        UiManager.Instance.AllPlayerJoinGameScene();
        OnAllCharacterSpawned?.Invoke();
        gameStarted = true;

        foreach (LocalPlayer _player in networkPlayers.Values.ToList())
        {
            if (!_player.IsInMyTeam(currentLocalPlayer.myPlayerModule.teamIndex))
            {
                allEnemies.Add(_player);
            }
        }

        if (RoomManager.Instance.actualRoom.roomType == RoomType.Tutorial)
        {
            TutorialManager.Instance.Tutorial();
        }
        else if (RoomManager.Instance.actualRoom.roomType == RoomType.Training)
        {
            TrainingManager.Instance.canvas.SetActive(true);
        }


    }

    public void ResetCam()
    {
        defaultCam.gameObject.SetActive(true);
        globalVolumeAnimator.SetBool("InBrume", false);
    }
    int oldTimerTrain = 0;
    void UpdateTime()
    {
        //if (inOvertime)
        //{
        //    overtime -= Time.deltaTime;
        //    UiManager.Instance.endZoneTimer.endZoneBarTimer.fillAmount = (overtime / baseOvertime);
        //}

        if (!trainTimerStarted)
        {
            timer += Time.deltaTime;
        }

        SetTimer(timer, UiManager.Instance.timer);

        if (isReviving)
        {
            reviveTimer -= Time.deltaTime;
            UiManager.Instance.reviveFill.fillAmount = reviveTimer / baseReviveTime;
            UiManager.Instance.reviveText.text = "Reviving in <color=blue>" + Math.Round(reviveTimer) + "</color>";

            if (reviveTimer <= 3 && !reviveFeedbackSet)
            {
                reviveFeedbackSet = true;

                Transform t = GetSpawnsOfTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam)[0].transform;

                LocalPoolManager.Instance.SpawnNewGenericInLocal(7, t.position, 0, 1, 3); // FOW

                NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(14, t.position + new Vector3(0, 0.1f, 0), new Vector3(-90, 0, 0), 3 - NetworkManager.Instance.GetLocalClient().Client.RoundTripTime.LatestRtt);
                CameraManager.Instance.SetFollowObj(t);
            }
            if (reviveTimer <= 0)
            {
                Revive(false);
                InGameNetworkReceiver.Instance.SendSpawnChamp(true);
                RoomManager.Instance.SpawnPlayerObj(NetworkManager.Instance.GetLocalPlayer().ID, true);
            }
        }

        if (endZoneStarted)
        {
            endZoneTimer -= Time.deltaTime;

            SetTimer(endZoneTimer, UiManager.Instance.endZoneUIGroup.timer);

            if (endZoneTimer <= 0)
            {
                endZoneStarted = false;

                ((EndZoneInteractible)InteractibleObjectsManager.Instance.interactibleList[3].interactible).TimerElapsed(); ;

                UiManager.Instance.endZoneUIGroup.TimerElapsed();
                SetTimer(0, UiManager.Instance.endZoneUIGroup.timer);
            }

        }
        if (trainTimerStarted)
        {
            trainTimer -= Time.deltaTime;

            if (oldTimerTrain != Mathf.RoundToInt(trainTimer))
            {
                oldTimerTrain = Mathf.RoundToInt(trainTimer);
                UiManager.Instance.trainTimer.text = oldTimerTrain.ToString();

                if (oldTimerTrain <= 5)
                {
                    blockMovement = true;
                    UiManager.Instance.trainAnimator.SetTrigger("DoScale");



                    if (oldTimerTrain == 0)
                    {
                        AudioManager.Instance.Play2DAudio(timerTrainSpawn);

                        _currentLocalPlayer.myPlayerModule.cancelSpell?.Invoke(false);
                        if ((_currentLocalPlayer.myPlayerModule.state & En_CharacterState.Intangenbility) == 0)
                            _currentLocalPlayer.myPlayerModule.CurrentSpellResolved().Interrupt();
                        _currentLocalPlayer.myPlayerModule.reduceAllCooldown(30);
                    }
                    else
                    {
                        AudioManager.Instance.Play2DAudio(timerTrain);
                    }
                }
            }

            if (trainTimer <= 0)
            {
                doFow = true;



                UiManager.Instance.trainPanel.SetActive(false);
                trainTimerStarted = false;

                if (NetworkManager.Instance.GetLocalPlayer().playerTeam != Team.spectator)
                {
                    foreach (SpawnPoint spawn in GetSpawnsOfTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam))
                    {
                        if (spawn.CanSpawn())
                        {
                            networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].transform.position = spawn.transform.position;

                        }
                    }
                }

                blockMovement = false;
            }
        }
    }
    public void Revive(bool state = false)
    {
        reviveFeedbackSet = false;
        UiManager.Instance.Revive(state);
        reviveTimer = baseReviveTime;
        isReviving = state;
    }
    public void SetOvertimeTimerState(bool state)
    {
        if (state)
        {
            overtime = baseOvertime;
        }
    }
    public int SetTimer(float timer, TextMeshProUGUI text = null)
    {
        int secondRemaining = (int)timer % 60;
        int minuteRemaining = (int)Math.Floor(timer / 60);

        text.text = minuteRemaining + " : " + secondRemaining.ToString("D2");

        return secondRemaining + (minuteRemaining * 60);
    }
    public void StartEndZone(Team team)
    {
        UiManager.Instance.endZoneUIGroup.Init(team);
        endZoneStarted = true;
    }
    private void StartTimerInServer()
    {
        timeStart = true;
    }
    public void QuitGame()
    {
        if (GameFactory.GetLocalPlayerObj() != null)
        {
            GameFactory.GetLocalPlayerObj().gameObject.SetActive(false);
        }

        RoomManager.Instance.QuitGame();
    }
    public void DelinkEverySpell()
    {
        currentLocalPlayer.myPlayerModule.leftClick.DelinkInput();
        currentLocalPlayer.myPlayerModule.firstSpell.DelinkInput();
        currentLocalPlayer.myPlayerModule.secondSpell.DelinkInput();
        currentLocalPlayer.myPlayerModule.SelectionnedSoulSpellModule().DelinkInput();
    }
    public void LinkTargetSpell(int _index)
    {
        switch (_index)
        {
            case (1):
                currentLocalPlayer.myPlayerModule.leftClick.LinkInputs(En_SpellInput.Click);
                break;
            case (2):
                currentLocalPlayer.myPlayerModule.firstSpell.LinkInputs(En_SpellInput.FirstSpell);
                break;
            case (3):
                currentLocalPlayer.myPlayerModule.secondSpell.LinkInputs(En_SpellInput.SecondSpell);
                break;
            case (4):
                currentLocalPlayer.myPlayerModule.SelectionnedSoulSpellModule().LinkInputs(En_SpellInput.SoulSpell);
                break;

        }
    }

    public bool HaveCapturedAnAltar(Team t)
    {
        foreach (Altar a in allAltar)
        {
            if (a.state == State.Captured && a.capturingTeam == t)
            {
                return true;
            }
        }

        return false;
    }
    #region DEPRECATED

    //internal void SpawnBrumeSoul(ushort brumeId)
    //{
    //    if (brumeSouls.ContainsKey(brumeId))
    //    {
    //        return;
    //    }

    //    BrumeSoul _soul = Instantiate(brumeSoul, allBrume[brumeId].spawnPoint.position, Quaternion.Euler(0,0,0)).GetComponent<BrumeSoul>();
    //    _soul.brumeIndex = brumeId;
    //    _soul.instanceID = allBrume[brumeId].GetInstanceID();
    //    brumeSouls.Add(brumeId, _soul);
    //}

    //internal void DeleteBrumeSoul(ushort brumeId)
    //{
    //    if (brumeSouls.ContainsKey(brumeId))
    //    {
    //        Destroy(brumeSouls[brumeId].gameObject);
    //        brumeSouls.Remove(brumeId);
    //    }
    //}

    #endregion
}
