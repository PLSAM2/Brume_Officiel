using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResurrectModule : SpellModule
{

    protected override bool canStartCanalisation()
    {
        WxController wxController = (WxController)myPlayerModule;

        if (wxController.GetPlayersSoulsCount() <= 0)
        {
            return false;
        }

        return base.canStartCanalisation();
    }
    protected override void Resolution()
    {
        WxController wxController = (WxController)myPlayerModule;

        ushort[] IDList = new ushort[wxController.GetPlayersSoulsCount()];


        for (int i = 0; i < wxController.GetPlayersSoulsCount(); i++)
        {
            IDList[i] = wxController.GetPlayersSoulsID(i);
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);
            _writer.Write(IDList);

            using (Message _message = Message.Create(Tags.ResurectPlayer, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }

        wxController.ClearPlayersSouls();
        base.Resolution();
    }
}
