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

    [TabGroup("WX")] [SerializeField] private ParticleSystem altarDebuffTrail;
    [TabGroup("WX")] public float outlineDebuffCooldown = 5;
    [TabGroup("WX")] public float outlineDebuffTime = 1.5f;
    [TabGroup("WX")] public List<GameObject> objectToShowOnOutlineDebuff = new List<GameObject>();

    private bool isDebuffTrailActive = false;
    private bool isDebuffOutlineActive = false;
    [HideInInspector] public Action soulPickedUp;


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
    public ushort GetPlayersSoulsID(int index)
    {
        return playerSouls[index];
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

    internal void ApplyOutlineDebuffInServer()
    {
        isDebuffOutlineActive = true;

        StartCoroutine(OutlineDebuff());
    }

    IEnumerator OutlineDebuff()
    {
        SetOutlineDebuff(true);

        yield return new WaitForSeconds(outlineDebuffTime);

        SetOutlineDebuff(false);

        yield return new WaitForSeconds(outlineDebuffCooldown);

        StartCoroutine(OutlineDebuff());
    }


    public void SetOutlineDebuff(bool value)
    {
        foreach (GameObject go in objectToShowOnOutlineDebuff)
        {
            go.SetActive(value);
        }

        mylocalPlayer.forceOutline = value;
    }
}
