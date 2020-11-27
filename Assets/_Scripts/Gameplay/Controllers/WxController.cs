using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WxController : PlayerModule
{
    [Header("Wu xin Properties")]


    private List<PlayerSoul> playerSouls = new List<PlayerSoul>();

    [SerializeField] private ParticleSystem altarDebuffTrail;
    private bool isDebuffTrailActive = false;


    protected override void StateChanged(En_CharacterState state)
    {
        base.StateChanged(state); 
        
        if ((state & En_CharacterState.WxMarked) != 0)
        {
            wxMark.SetActive(true);
        }
        else
        {
            wxMark.SetActive(false);
        }
    }

    public void PickPlayerSoul(PlayerSoul playerSoul)
    {
        print("I picked a soul");
        playerSouls.Add(playerSoul);
       // this.GetComponent<Module_WxSoulBurst>().charges++;
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
