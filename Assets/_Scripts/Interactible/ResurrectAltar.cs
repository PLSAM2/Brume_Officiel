using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResurrectAltar : Interactible
{
    void Start()
    {
        base.Init();
    }

    public override void Captured(GameData.Team team)
    {
        base.Captured(team);

        WxController wxController = (WxController)capturingPlayerModule;

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
                client.SendMessage(_message, SendMode.Reliable);
            }
        }

        wxController.ClearPlayersSouls();
    }

    public override void TryCapture(GameData.Team team, PlayerModule capturingPlayer)
    {
        WxController wxController = (WxController)capturingPlayer;

        if (wxController.GetPlayersSoulsCount() <= 0)
        {
            return;
        }

        base.TryCapture(team, capturingPlayer);
    }

    public override void UpdateCaptured(GameData.Team team) // capture recu par tout les client
    {
        base.UpdateCaptured(team);
        state = State.Capturable;
    }



}
