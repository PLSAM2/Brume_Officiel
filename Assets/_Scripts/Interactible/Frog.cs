using Sirenix.OdinInspector;
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

    private void OnEnable()
    {
        base.capturedEvent += Captured;
        base.leaveEvent += StopCapturing;
    }

    private void OnDisable()
    {
        base.capturedEvent -= Captured;
        base.leaveEvent -= StopCapturing;
    }

    public override void Captured(GameData.Team team) // quand capturer en local
    {
        base.Captured(team);
        nest.FrogPicked();

        //Ajoute une ward 
        if (capturingPlayerModule.GetComponent<WardModule>() != null)
        {
            capturingPlayerModule.GetComponent<WardModule>().AddCharge();
        }
    }


    public override void UpdateCaptured(GameData.Team team) // capture recu par tout les client
    {
        base.UpdateCaptured(team);
        state = State.Capturable;
        // Respawn 
        nest.FrogPicked();
    }

}
