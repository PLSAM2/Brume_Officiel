using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Ward : MonoBehaviour
{
    public float lifeTime = 60;
    public Fow fowFollow;

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

            if (GameManager.Instance.currentLocalPlayer != null && GameManager.Instance.currentLocalPlayer.myPlayerModule.isInBrume)
            {
                fowFollow.gameObject.SetActive(false);
            }
        }
    }

    public void DestroyWard()
    {
        fowFollow.gameObject.SetActive(false);
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
