using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class AltarBuffPoison : AltarBuff
{
    public override void InitBuff(PlayerModule capturingPlayerModule)
    {
        base.InitBuff(capturingPlayerModule);
        ApplyAltarPoisonBuff(capturingPlayerModule.teamIndex);
    }

    public void ApplyAltarPoisonBuff(Team capturingPlayerTeam)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write((ushort)capturingPlayerTeam);

            using (Message _message = Message.Create(Tags.AltarPoisonBuff, _writer))
            {
                RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }
}
