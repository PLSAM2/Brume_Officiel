using DarkRift;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

[CreateAssetMenu(fileName = "AltarBuff", menuName = "Custom/AltarBuff/AltarBuffSpeed")]
public class AltarBuffSpeed : AltarBuff
{
    public override void InitBuff(PlayerModule capturingPlayerModule)
    {
        base.InitBuff(capturingPlayerModule);
        ApplyAltarSpeedBuff(capturingPlayerModule.teamIndex);
    }

    public void ApplyAltarSpeedBuff(Team capturingPlayerTeam)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write((ushort)capturingPlayerTeam);

            using (Message _message = Message.Create(Tags.AltarSpeedBuff, _writer))
            {
                RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }


}
