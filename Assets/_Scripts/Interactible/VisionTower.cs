﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisionTower : Interactible
{
    [Header("Vision Tower properties")]
    public Fow vision;


    void Start()
    {
        base.Init();
        base.Unlock();
    }

    public override void Captured(GameData.Team team)
    {
        base.Captured(team);
    }

    public override void UpdateCaptured(GameData.Team team)
    {
        base.UpdateCaptured(team);

        if (team == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            vision.gameObject.SetActive(true);
            vision.Init();
        }
        else
        {
            vision.gameObject.SetActive(false);
        }

    }

    public void ReactivateTower()
    {
        base.Unlock();
    }
}
