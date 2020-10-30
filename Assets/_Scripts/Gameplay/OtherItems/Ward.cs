using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ward : MonoBehaviour
{
    public float lifeTime = 60;
    [SerializeField] private Fow fowFollow;

    public void Landed(GameData.Team Team)
    {
        if (Team != RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            this.gameObject.SetActive(false);
        } else
        {
            fowFollow.Init();
            StartCoroutine(WardLifeTime());
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



}
