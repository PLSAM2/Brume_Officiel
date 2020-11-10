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

        ushort[] IDList = new ushort[capturingPlayerModule.playerSouls.Count];

        for (int i = 0; i < capturingPlayerModule.playerSouls.Count; i++)
        {
            IDList[i] = capturingPlayerModule.playerSouls[i].soulInfo.ID;
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

        capturingPlayerModule.playerSouls.Clear();
    }

    public override void UpdateCaptured(GameData.Team team) // capture recu par tout les client
    {
        base.UpdateCaptured(team);
        state = State.Capturable;
    }



}
