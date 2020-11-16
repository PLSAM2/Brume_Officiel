using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShiliController : PlayerModule
{
    [Header("Shili Properties")]

    [SerializeField] private ParticleSystem altarDebuffTrail;
    private bool isDebuffTrailActive = false;

    public void ApplyAltarTrailDebuffInServer()
    {
        isDebuffTrailActive = true;

        if (!isInBrume)
        {
            SetAltarDebuffTrailState(true);
        }
    }

    public override void SetInBrumeStatut(bool _value)
    {
        base.SetInBrumeStatut(_value);

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
