using DarkRift;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

[InlineEditor]
[CreateAssetMenu(fileName = "AltarBuff", menuName = "Custom/AltarBuff/AltarBuffOutline")]
public class AltarBuffOutline : AltarBuff
{
    public override void InitBuff(PlayerModule capturingPlayerModule)
    {
        base.InitBuff(capturingPlayerModule);
        ApplyOutlineDebuff(capturingPlayerModule.mylocalPlayer.myPlayerId);
    }

    public void ApplyOutlineDebuff(ushort capturingPlayer)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(capturingPlayer);

            using (Message _message = Message.Create(Tags.AltarOutlineBuff, _writer))
            {
                RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }


}
