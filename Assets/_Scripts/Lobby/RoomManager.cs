using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
using static GameData;
using static StatFactory;

public class RoomManager : MonoBehaviour
{
    private static RoomManager _instance;
    public static RoomManager Instance { get { return _instance; } }

    public string gameScene;
    public string loadingGameScene;
    public string champSelectScene;
    public string menuScene;
    public string trainingScene;
    public string loadingTrainingScene;
    public string loadingTutorialScene;

    public RoomData actualRoom;

    public UnityClient client;
    public bool AlreadyInit = false;

    [Header("ActualGameInfo")]
    public int roundCount = 0;
    public Dictionary<ushort, ushort> InGameUniqueIDList = new Dictionary<ushort, ushort>();
    [HideInInspector] public Dictionary<Team, ushort> assignedSpawn = new Dictionary<Team, ushort>();

    [Header("EndGameInfo")]
    public bool isNewRound = false;

    //SPAWN
    [SerializeField] GameObject prefabShili;
    [SerializeField] GameObject prefabRe;
    [SerializeField] GameObject prefabLeng;

    public List<ushort> delayedPlayerSpawn = new List<ushort>();

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

        client.MessageReceived += MessageReceived;

    }

    private void Start()
    {
        NetworkManager.Instance.OnPlayerQuit += OnPlayerQuitGame;

        assignedSpawn.Add(Team.red, 0);
        assignedSpawn.Add(Team.blue, 0);
    }

    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
        NetworkManager.Instance.OnPlayerQuit -= OnPlayerQuitGame;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SpawnObjPlayer)
            {
                SpawnPlayerObjReceiver(sender, e);
            }
            if (message.Tag == Tags.SwapHostRoom)
            {
                SwapHost(sender, e);
            }
            if (message.Tag == Tags.LobbyStartGame)
            {
                StartChampSelectInServer();
            }
            if (message.Tag == Tags.StartGame)
            {
                StartGameInServer(sender, e);
            }
            if (message.Tag == Tags.AddPoints)
            {
                AddPointsInServer(sender, e);
            }
            if (message.Tag == Tags.NewRound)
            {
                NewRoundInServer(sender, e);
            }
            if (message.Tag == Tags.StopGame)
            {
                StopGameInServer(sender, e);
            }
            if (message.Tag == Tags.SetInGameUniqueID)
            {
                SetInGameUniqueIDInServer(sender, e);
            }
            if (message.Tag == Tags.QuitRoom)
            {
                QuitGameInServer();
            }
            if (message.Tag == Tags.StatsSkip)
            {
                SkipToNext();
            }
        }
    }

    private void NewRoundInServer(object sender, MessageReceivedEventArgs e)
    {
        GameManager.Instance.OnRoundFinish?.Invoke();
        StartNewRound();
        Team winningTeam = Team.none;
        bool wuxinKilled = true;

        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                winningTeam = (Team)reader.ReadUInt16();
                ushort redTeamAssignement = reader.ReadUInt16();
                ushort blueTeamAssignement = reader.ReadUInt16();

                if (reader.ReadBoolean() == true)
                {
                    ushort killedPlayerID = reader.ReadUInt16();
                    ushort killerPlayerID = reader.ReadUInt16();

                    GameManager.Instance.OnPlayerDie?.Invoke(killedPlayerID, killerPlayerID);
                } else
                {
                    wuxinKilled = false;
                }

                assignedSpawn[Team.red] = redTeamAssignement;
                assignedSpawn[Team.blue] = blueTeamAssignement;
            }
        }

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == winningTeam)
        {
            UiManager.Instance.EndGamePanel(true, winningTeam, wuxinKilled);
            EndObjectives(true, wuxinKilled);
        }
        else
        {
            UiManager.Instance.EndGamePanel(false, winningTeam, wuxinKilled);
            EndObjectives(false, wuxinKilled);
        }

        InGameNetworkReceiver.Instance.SetEndGame(true);

        StartCoroutine(EndGame());
    }

    internal bool PlayerExist(ushort playerID)
    {
        return actualRoom.playerList.ContainsKey(playerID);
    }

    private void EndObjectives(bool isRoundWin = false, bool wuxinKilled = false)
    {

        foreach (KeyInteractiblePair kip in InteractibleObjectsManager.Instance.interactibleList)
        {
            kip.interactible.StopCapturing();
        }

        ushort? _wxID = null;
        CameraManager.Instance.endGame = true;
        if (wuxinKilled)
        {
            if (isRoundWin)
            {
                _wxID = GameFactory.GetPlayerCharacterInEnemyTeam(Character.WuXin);
            }
            else
            {
                _wxID = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, Character.WuXin);
            }

            if (_wxID != null)
            {
                if (GameManager.Instance.networkPlayers.ContainsKey((ushort)_wxID))
                {

                    LocalPlayer _wx = GameManager.Instance.networkPlayers[(ushort)_wxID];
                    CameraManager.Instance.SetFollowObj(_wx.transform);
                    LocalPoolManager.Instance.SpawnNewGenericInLocal(7, _wx.transform.position, 0, 1);
                    _wx.myPlayerModule.willListenInputs = false;
                    _wx.ForceDealDamages(_wx.liveHealth);
                }
            }
          
        } else { 

            CameraManager.Instance.SetFollowObj(InteractibleObjectsManager.Instance.interactibleList[3].interactible.transform);
            LocalPoolManager.Instance.SpawnNewGenericInLocal(7, InteractibleObjectsManager.Instance.interactibleList[3].interactible.transform.position, 0, 1);
        }     
        
    }

    IEnumerator EndGame()
    {
        Time.timeScale = Time.timeScale / 4;

        yield return new WaitForSeconds(1);

        Time.timeScale = 1;

        UiManager.Instance.InitEndGameStats();
    }

    public void SkipToNext()
    {
        if (isNewRound)
        {
            SceneManager.LoadScene(gameScene, LoadSceneMode.Single);
        }
        else
        {
            ResetActualGame();
            StartChampSelectInServer();
        }
    }

    private void StopGameInServer(object sender, MessageReceivedEventArgs e)
    {
        GameManager.Instance.OnGameFinish?.Invoke();

        isNewRound = false;
        Team winningTeam = Team.none;
        bool wuxinKilled = true;
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                winningTeam = (Team)reader.ReadUInt16();

                if (reader.ReadBoolean() == true)
                {
                    ushort killedPlayerID = reader.ReadUInt16();
                    ushort killerPlayerID = reader.ReadUInt16();

                    GameManager.Instance.OnPlayerDie?.Invoke(killedPlayerID, killerPlayerID);
                } else
                {
                    wuxinKilled = false;
                }
            }
        }

        if (winningTeam == Team.none)
        {
            ResetActualGame();
            StartChampSelectInServer();
            return;
        }

        StatFactory.AddIntStat(NetworkManager.Instance.GetLocalPlayer().playerCharacter, statType.Game);

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == winningTeam)
        {
            StatFactory.AddIntStat(NetworkManager.Instance.GetLocalPlayer().playerCharacter, statType.Win);

            UiManager.Instance.EndGamePanel(true, winningTeam, wuxinKilled);
            EndObjectives(true);
        }
        else
        {
            UiManager.Instance.EndGamePanel(false, winningTeam, wuxinKilled);
            EndObjectives(false);
        }

        InGameNetworkReceiver.Instance.SetEndGame(true);

        StartCoroutine(EndGame());

    }


    public void StartChampSelect()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(actualRoom.ID);

            using (Message message = Message.Create(Tags.LobbyStartGame, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    public void StartChampSelectInServer()
    {
        AlreadyInit = true;
        StartNewRound();
        ResetPlayersReadyStates();
        SceneManager.LoadScene(champSelectScene, LoadSceneMode.Single);
    }

    private void StartGameInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                assignedSpawn[Team.red] = reader.ReadUInt16();
                assignedSpawn[Team.blue] = reader.ReadUInt16();
            }
        }
        SceneManager.LoadScene(loadingGameScene, LoadSceneMode.Single);
    }


    private void StartNewRound()
    {
        isNewRound = true;
        roundCount++;
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
                UpdatePointDisplay();
            }
        }
    }
    private void SwapHost(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort playerID = reader.ReadUInt16();

                PlayerData player = RoomManager.Instance.actualRoom.playerList[playerID];

                if (LobbyManager.Instance != null)
                {
                    LobbyManager.Instance.roomPanelControl.SetHost(player, true);
                }

                if (NetworkManager.Instance.GetLocalPlayer().ID == player.ID)
                {
                    NetworkManager.Instance.GetLocalPlayer().IsHost = true;
                }
            }
        }

    }

    // PLYER SPAWN 

    void SpawnPlayerObjReceiver(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort id = reader.ReadUInt16();
                bool isResurecting = reader.ReadBoolean();

                if (NetworkManager.Instance.GetLocalPlayer().ID != id)
                {
                    if (GameManager.Instance == null || GameManager.Instance.playerJoinedAndInit == false) // SI ON A RECU UNE DEMANDE DE SPAWN PENDANT LE LOAD
                    {
                        delayedPlayerSpawn.Add(id);
                        return;
                    }
                }

                if (GameManager.Instance.networkPlayers.ContainsKey(id)) { return; }

                SpawnPlayerObj(id, isResurecting);
            }
        }
    }

    internal void SpawnPlayerObj(ushort id, bool isResurecting)
    {
        Vector3 spawnPos = Vector3.zero;

        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == Team.spectator)
        {
            return;
        }

        foreach (SpawnPoint spawn in GameManager.Instance.GetSpawnsOfTeam(RoomManager.Instance.actualRoom.playerList[id].playerTeam))
        {
            if (spawn.CanSpawn())
            {
                spawnPos = spawn.transform.position;
            }
        }

        //else
        //{
        //    bool emptySpace = false;

        //    foreach (SpawnPoint spawn in GameManager.Instance.resSpawns)
        //    {
        //        if (spawn.CanSpawn())
        //        {
        //            emptySpace = true;
        //            spawnPos = spawn.transform.position;
        //        }
        //    }

        //    if (!emptySpace)
        //    {
        //        spawnPos = GameManager.Instance.resSpawns[1].transform.position;
        //    }
        //}


        GameObject obj = null;

        switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
        {
            case Character.WuXin:
                obj = Instantiate(prefabShili, spawnPos, Quaternion.identity);
                break;

            case Character.Re:
                obj = Instantiate(prefabRe, spawnPos, Quaternion.identity);
                break;

            case Character.Leng:
                obj = Instantiate(prefabLeng, spawnPos, Quaternion.identity);
                break;
            default:
                using (DarkRiftWriter _writer = DarkRiftWriter.Create())
                {
                    using (Message _message = Message.Create(Tags.AskForStopGame, _writer))
                    {
                        client.SendMessage(_message, SendMode.Reliable);
                    }
                }
                throw new Exception("CHARACTER NONE LORS DU LANCEMENT D'UNE PARTIE");
        }

        LocalPlayer myLocalPlayer = obj.GetComponent<LocalPlayer>();
        myLocalPlayer.myPlayerId = id;
        myLocalPlayer.isOwner = client.ID == id;
        myLocalPlayer.Init(client, true);

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

            //if (myLocalPlayer.isOwner)
            //{
            //    TeleportationModule _tp = (TeleportationModule)myLocalPlayer.myPlayerModule.tpModule;
            //    _tp.TpOnRes();
            //}
        }

    }
    internal void SpawnDelayedPlayer()
    {
        foreach (ushort id in delayedPlayerSpawn)
        {
            SpawnPlayerObj(id, false);
        }

        delayedPlayerSpawn.Clear();

        if (actualRoom.roomType == RoomType.Classic || actualRoom.roomType == RoomType.Training)
        {
            UiManager.Instance.DisplaySoulSpell();
        } else
        {
            TutorialManager.Instance.PlayerSpawned();
        }

    }

    public void ImReady()
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

    public void UpdatePointDisplay()
    {
        if (UiManager.Instance != null)
        {
            if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
            {
                UiManager.Instance.allyScore.text = actualRoom.scores[Team.red].ToString();
            }
            else
            {
                UiManager.Instance.allyScore.text = actualRoom.scores[NetworkManager.Instance.GetLocalPlayer().playerTeam].ToString();
            }


            switch (NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                case Team.red:
                    UiManager.Instance.ennemyScore.text = RoomManager.Instance.actualRoom.scores[Team.blue].ToString();
                    break;
                case Team.blue:
                    UiManager.Instance.ennemyScore.text = RoomManager.Instance.actualRoom.scores[Team.red].ToString();
                    break;
                case Team.spectator:
                    UiManager.Instance.ennemyScore.text = RoomManager.Instance.actualRoom.scores[Team.blue].ToString();
                    break;
                default:
                    throw new System.Exception("ERREUR equipe non existante");
            }
        }
    }

    private void SetInGameUniqueIDInServer(object sender, MessageReceivedEventArgs e)
    {
        InGameUniqueIDList.Clear();

        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort temp = 0;
                ushort[] _IDs = reader.ReadUInt16s();

                foreach (ushort id in _IDs)
                {
                    temp++;
                    InGameUniqueIDList.Add(id, temp);
                }
            }
        }
    }

    public ushort GetLocalPlayerUniqueID()
    {
        return InGameUniqueIDList[NetworkManager.Instance.GetLocalPlayer().ID];
    }

    public void ResetActualGame()
    {
        if (actualRoom != null && actualRoom.scores.ContainsKey(Team.red))
        {
            actualRoom.scores[Team.red] = 0;
            actualRoom.scores[Team.blue] = 0;

            foreach (PlayerData p in actualRoom.playerList.Values)
            {
                p.playerCharacter = Character.none;
                p.ultStacks = 0;
            }
        }
        isNewRound = false;
        roundCount = 0;
    }

    public void ResetPlayersReadyStates()
    {
        foreach (KeyValuePair<ushort, PlayerData> p in actualRoom.playerList)
        {
            p.Value.IsReady = false;
        }
    }

    public PlayerData GetPlayerData(ushort id)
    {
        return actualRoom.playerList[id];
    }

    private void OnPlayerQuitGame(PlayerData obj)
    {
        InGameUniqueIDList.Remove(obj.ID);
        actualRoom.playerList.Remove(obj.ID);
    }

    public void QuitGame()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message message = Message.Create(Tags.QuitRoom, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }


    public void QuitGameInServer()
    {
        if (SceneManager.GetActiveScene().name == menuScene)
        {
            return;
        }

        NetworkManager.Instance.GetLocalPlayer().ResetGameData();
        SceneManager.LoadScene(menuScene, LoadSceneMode.Single);
        ResetActualGame();
    }

    internal void TryAddUltimateStacks(ushort playerId, ushort value, bool set = false)
    {
        if (NetworkManager.Instance.GetLocalPlayer() == null) { return; }

        PlayerData p = RoomManager._instance.GetPlayerData(playerId);

        if (actualRoom.playerList[playerId].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            if (set)
            {
                p.ultStacks = value;
            }
            else
            {
                p.ultStacks += value;

            }

            GameManager.Instance.currentLocalPlayer.myPlayerModule.ultPointPickedUp?.Invoke();
        }
    }

    internal void TryUseUltStacks(ushort stacksUsed)
    {
        ushort pId = NetworkManager.Instance.GetLocalPlayer().ID;
        if (!GameManager.Instance.networkPlayers.ContainsKey(pId)) { return; }

        PlayerData p = NetworkManager.Instance.GetLocalPlayer();
        if (p.ultStacks >= stacksUsed)
        {
            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(stacksUsed);

                using (Message _message = Message.Create(Tags.UseUltPoint, _writer))
                {
                    client.SendMessage(_message, SendMode.Reliable);
                }
            }
        }

    }

    internal ushort GetPlayerUltStacks(ushort id)
    {
        if (!GameManager.Instance.networkPlayers.ContainsKey(id)) { return 0; }
        if (actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return actualRoom.playerList[id].ultStacks;
        }

        return 0;
    }



}
