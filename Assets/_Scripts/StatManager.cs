using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using static altarEvent;
using static GameData;
using static StatFactory;

public class StatManager : MonoBehaviour
{
    public Dictionary<ushort, ushort> damagePlayer = new Dictionary<ushort, ushort>();
    public Dictionary<ushort, ushort> killPlayer = new Dictionary<ushort, ushort>();

    public Dictionary<statEvent, float> timeLineEvent = new Dictionary<statEvent, float>();

    public float endGameTime = 0;

    private static StatManager _instance;
    public static StatManager Instance { get { return _instance; } }
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
    }

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
        GameManager.Instance.OnPlayerGetDamage += OnPlayerGetDamage;
        GameManager.Instance.OnRoundFinish += OnRoundFinish;
        GameManager.Instance.OnGameFinish += OnGameFinish;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerGetDamage -= OnPlayerGetDamage;
        GameManager.Instance.OnRoundFinish -= OnRoundFinish;
        GameManager.Instance.OnGameFinish -= OnGameFinish;
    }

    void OnPlayerDie(ushort _idPlayer, ushort _killer)
    {
        if (InGameNetworkReceiver.Instance.GetEndGame())
        {
            return;
        }

        killEvent newKill = new killEvent(_idPlayer, _killer);
        timeLineEvent.Add(newKill, GameManager.Instance.timer);

        if (killPlayer.ContainsKey(_killer))
        {
            killPlayer[_killer] += 1;
        }
        else
        {
            killPlayer.Add(_killer, 1);
        }

        if(_idPlayer == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            StatFactory.AddIntStat(NetworkManager.Instance.GetLocalPlayer().playerCharacter, statType.Time, (int)Math.Floor(GameManager.Instance.timer / 60));
            PlayerPrefs.SetInt("currentDeath", PlayerPrefs.GetInt("currentDeath") +1);
        }

        if (_killer == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            StatFactory.AddIntStat(NetworkManager.Instance.GetLocalPlayer().playerCharacter, statType.Kill);
        }
    }

    void OnPlayerGetDamage(ushort _idPlayer, ushort _damage, ushort _dealer)
    {
        if (damagePlayer.ContainsKey(_dealer))
        {
            damagePlayer[_dealer] += _damage;
        }
        else
        {
            damagePlayer.Add(_dealer, _damage);
        }
    }

    public void AddAltarEvent(state _altarState, string _altarPos, Team myTeam = Team.none)
    {
        if (InGameNetworkReceiver.Instance.GetEndGame())
        {
            return;
        }

        altarEvent newAltarEvent = new altarEvent(_altarState, _altarPos);

        if(myTeam != Team.none)
        {
            newAltarEvent.myTeam = myTeam;
        }

        timeLineEvent.Add(newAltarEvent, GameManager.Instance.timer);
    }

    void OnRoundFinish()
    {
        if(killPlayer.ContainsKey(NetworkManager.Instance.GetLocalPlayer().ID))
        {
            PlayerPrefs.SetInt("currentKill", PlayerPrefs.GetInt("currentKill") + killPlayer[NetworkManager.Instance.GetLocalPlayer().ID]);
        }

        if (damagePlayer.ContainsKey(NetworkManager.Instance.GetLocalPlayer().ID))
        {
            PlayerPrefs.SetInt("currentDamage", PlayerPrefs.GetInt("currentDamage") + damagePlayer[NetworkManager.Instance.GetLocalPlayer().ID]);
        }

        if(GameManager.Instance.currentLocalPlayer != null)
        {
            StatFactory.AddIntStat(NetworkManager.Instance.GetLocalPlayer().playerCharacter, statType.Time, (int)Math.Floor(GameManager.Instance.timer / 60));
        }
    }

    void OnGameFinish()
    {
        OnRoundFinish();

        int yourScore = RoomManager.Instance.actualRoom.scores[NetworkManager.Instance.GetLocalPlayer().playerTeam];
        int enemyScore = RoomManager.Instance.actualRoom.scores[GameFactory.GetOtherTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam)];

        //create json
        StatGame newStatGame = new StatGame(NetworkManager.Instance.GetLocalPlayer().playerCharacter, yourScore, enemyScore, PlayerPrefs.GetInt("currentKill"), PlayerPrefs.GetInt("currentDeath"), PlayerPrefs.GetInt("currentDamage"));

        List<StatGame> allGames = new List<StatGame>();
        allGames.Add(newStatGame);

        if (!Directory.Exists(Application.persistentDataPath + "/Games"))
        {
            print(Application.persistentDataPath);
            Directory.CreateDirectory(Application.persistentDataPath + "/Games");
            File.Create(Application.persistentDataPath + "/Games/allGames.json").Dispose();
        }
        else
        {
            string input = File.ReadAllText(Application.persistentDataPath + "/Games/allGames.json");
            List<StatGame> temp = JsonConvert.DeserializeObject<List<StatGame>>(input);
            allGames.AddRange(temp);
        }

        string output = JsonConvert.SerializeObject(allGames, Formatting.Indented);

        File.WriteAllText(Application.persistentDataPath + "/Games/allGames.json", output);
    }
}

public class statEvent
{
    public type myTypeEvent;

    public enum type
    {
        kill,
        altar
    }
}

public class killEvent : statEvent
{
    public ushort idPlayer;
    public ushort idKiller;

    public killEvent(ushort _idPlayer, ushort _idKiller)
    {
        myTypeEvent = type.kill;
        idPlayer = _idPlayer;
        idKiller = _idKiller;
    }
}

public class altarEvent : statEvent
{
    public state myState;
    public string altarPos;
    public Team myTeam;

    public altarEvent(state _myState, string _altarPos)
    {
        myTypeEvent = type.altar;
        myState = _myState;
        altarPos = _altarPos;
    }

    public enum state
    {
        AWAKENS,
        UNSEALED,
        CLEANSED
    }
}


[System.Serializable]
public class StatGame
{
    public Character champ;
    public int yourScore;
    public int enemyScore;
    public int kill;
    public int death;
    public int damage;

    public StatGame(Character _champ, int _yourScore, int _enemyScore, int _kill, int _death, int _damage)
    {
        champ = _champ;
        yourScore = _yourScore;
        enemyScore = _enemyScore;
        kill = _kill;
        death = _death;
        damage = _damage;
    }
}