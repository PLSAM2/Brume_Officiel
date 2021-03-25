using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static altarEvent;

public class StatManager : MonoBehaviour
{
    Dictionary<ushort, ushort> damagePlayer = new Dictionary<ushort, ushort>();

    Dictionary<float, statEvent> timeLineEvent = new Dictionary<float, statEvent>();

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
        killEvent newKill = new killEvent(_idPlayer, _killer);
        timeLineEvent.Add(GameManager.Instance.timer, newKill);
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

    public void AddAltarEvent(state _altarState, string _altarPos)
    {
        altarEvent newAltarEvent = new altarEvent(_altarState, _altarPos);
        timeLineEvent.Add(GameManager.Instance.timer, newAltarEvent);
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