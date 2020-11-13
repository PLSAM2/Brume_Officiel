using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Frog : Interactible
{
    [Header("Frog properties")]
    [ReadOnly] public FrogNest nest;

    void Start()
    {
        base.Init();
    }


    public override void Captured(GameData.Team team) // quand capturer en local
    {
        base.Captured(team);
        nest.FrogPicked(capturingPlayerModule);

        //Ajoute une ward 
        if (capturingPlayerModule.GetComponent<WardModule>() != null)
        {
            capturingPlayerModule.GetComponent<WardModule>().AddCharge();
        }
    }
    public override void TryCapture(GameData.Team team, PlayerModule capturingPlayer)
    {
        if (capturingPlayerModule.GetComponent<WardModule>() != null)
        {
            if (capturingPlayerModule.GetComponent<WardModule>().charges >= 1)
            {
                return;
            } 
        }

        base.TryCapture(team, capturingPlayer);
    }

    public override void UpdateCaptured(GameData.Team team) // capture recu par tout les client
    {
        base.UpdateCaptured(team);
        state = State.Capturable;
        // Respawn 
        nest.FrogPicked(capturingPlayerModule);
    }

    internal void RespawnFrog()
    {
        nest.SpawnFrog();
    }
}
