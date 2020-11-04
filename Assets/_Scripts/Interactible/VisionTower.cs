using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisionTower : Interactible
{
    [Header("Vision Tower properties")]
    public float unlockTime;
    public Fow vision;


    void Start()
    {
        base.Init();
    }

    public override void Captured(GameData.Team team)
    {
        base.Captured(team);

        StartCoroutine(ReactivateTower());
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

    IEnumerator ReactivateTower()
    {
        yield return new WaitForSeconds(unlockTime);

        base.Unlock();
    }


}
