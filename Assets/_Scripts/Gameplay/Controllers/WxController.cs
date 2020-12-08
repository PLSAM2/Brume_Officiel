using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class WxController : PlayerModule
{
    [Header("Wu xin Properties")]

    [TabGroup("WX")] List<ushort> playerSouls = new List<ushort>();

    [TabGroup("FeedbacksState")] [SerializeField] private ParticleSystem altarDebuffTrail;
    private bool isDebuffTrailActive = false;
    public Action soulPickedUp;


    protected override void Update()
    {
        base.Update();

        foreach (ushort p in playerSouls)
        {
            print(RoomManager.Instance.GetPlayerData(p).playerTeam + " / " + RoomManager.Instance.GetPlayerData(p).playerCharacter.ToString() + " / " + p);
        }

    }
    public void PickPlayerSoul(ushort playerSoul)
    {
        playerSouls.Add(playerSoul);
        soulPickedUp?.Invoke();
        // this.GetComponent<Module_WxSoulBurst>().charges++;
    }

    public void PickBrumeSoul()
    {
        soulPickedUp?.Invoke();
        // this.GetComponent<Module_WxSoulBurst>().charges++;
    }

    public int GetPlayersSoulsCount()
    {
        return playerSouls.Count;
    }
    public void ClearPlayersSouls()
    {
        playerSouls.Clear();
    }

    public void ApplyAltarTrailDebuffInServer()
    {
        isDebuffTrailActive = true;

        if (!isInBrume)
        {
            SetAltarDebuffTrailState(true);
        }
    }

    public override void SetInBrumeStatut(bool _value, int brumeId)
    {
        base.SetInBrumeStatut(_value, brumeId);

        if (isDebuffTrailActive)
        {
            SetAltarDebuffTrailState(!_value);
        }
    }
    
    public void SetAltarDebuffTrailState(bool value)
    {
        if (value)
        {
            altarDebuffTrail.Play();
            print("play");
        }
        else
        {
            altarDebuffTrail.Stop();
            print("stop");
        }
    }

}
