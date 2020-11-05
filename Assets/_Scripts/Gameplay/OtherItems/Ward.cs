﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Ward : MonoBehaviour
{
    public float lifeTime = 60;
    [SerializeField] private Fow fowFollow;

    Team myTeam;

    public void Landed(Team _team)
    {
        myTeam = _team;
        if (_team != RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            this.DestroyWard();
        } else
        {
            fowFollow.gameObject.SetActive(true);
            fowFollow.Init();
            StartCoroutine(WardLifeTime());

            GameManager.Instance.allWard.Add(this);
        }
    }

    public void DestroyWard()
    {
        this.gameObject.SetActive(false);
    }
    IEnumerator WardLifeTime()
    {
        yield return new WaitForSeconds(lifeTime);
        DestroyWard();

    }

    private void OnDisable()
    {
        if (myTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            GameManager.Instance.allWard.Remove(this);
        }
    }
}
