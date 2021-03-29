using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static altarEvent;
using static GameData;

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
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerGetDamage -= OnPlayerGetDamage;
    }

    void OnPlayerDie(ushort _idPlayer, ushort _killer)
    {
        print("player die");

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