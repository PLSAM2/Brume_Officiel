using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisionTower : Interactible
{
    [Header("Vision Tower properties")]
    public float unlockTime;
    public FowFollow vision;


    void Start()
    {
        base.Init();
        base.capturedEvent += Captured;
        base.leaveEvent += StopCapturing;
    }

    private void OnDisable()
    {
        base.capturedEvent -= Captured;
        base.leaveEvent -= StopCapturing;
    }

    public override void Captured(GameData.Team team)
    {
        base.Captured(team);

        if (team == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            vision.gameObject.SetActive(true);
            vision.Init();

        }
        else
        {
            vision.gameObject.SetActive(false);
        }

        StartCoroutine(ReactivateTower());
    }

    IEnumerator ReactivateTower()
    {
        yield return new WaitForSeconds(unlockTime);

        base.Unlock();
    }


}
