using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UltPickup : Interactible
{
    public ushort ultimateStackGive = 1;
    public override void Captured(ushort _capturingPlayerID)
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(ultimateStackGive);

            using (Message message = Message.Create(Tags.AddUltimatePoint, writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
            }
        }

        base.Captured(_capturingPlayerID);
    }

}
