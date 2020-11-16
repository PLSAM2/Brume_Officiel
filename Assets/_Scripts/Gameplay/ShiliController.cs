using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShiliController : PlayerModule
{

    [Header("Shili Properties")]

    [SerializeField] private ParticleSystem altarDebuffTrail;
    private bool isDebuffTrailActive = false;

    public void ApplyAltarTrailDebuff()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(mylocalPlayer.myPlayerId);

            using (Message _message = Message.Create(Tags.AltarTrailDebuff, _writer))
            {
                RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    public void ApplyAltarTrailDebuffInServer()
    {
        isDebuffTrailActive = true;

        if (isInBrume)
        {
            SetAltarDebuffTrailState(true);
        }
    }

    public override void SetInBrumeStatut(bool _value, int brumeId)
    {
        base.SetInBrumeStatut(_value, brumeId);

        if (isDebuffTrailActive)
        {
            SetAltarDebuffTrailState(_value);
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
