using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WxController : PlayerModule
{
    [Header("Wu xin Properties")]


    public int playerSoulsCharge = 0;
    private List<PlayerSoul> playerSouls = new List<PlayerSoul>();

    [SerializeField] private ParticleSystem altarDebuffTrail;
    private bool isDebuffTrailActive = false;

    public void PickPlayerSoul(PlayerSoul playerSoul)
    {
        playerSouls.Add(playerSoul);
        playerSoulsCharge++;
    }

    public int GetPlayersSoulsCount()
    {
        return playerSouls.Count;
    }
    public ushort GetPlayersSoulsID(int index)
    {
        return playerSouls[index].soulInfo.ID;
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
        } else
        {
            altarDebuffTrail.Stop();
        }
    }

}
