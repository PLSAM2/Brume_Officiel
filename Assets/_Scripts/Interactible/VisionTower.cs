using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisionTower : Interactible
{
    [Header("Vision Tower properties")]
    public float unlockTime;

    void Start()
    {
        base.Init();
        base.capturedEvent += Captured;
        base.leaveEvent += StopCapturing;
        isInteractable = false;
    }

    private void OnDisable()
    {
        base.capturedEvent -= Captured;
        base.leaveEvent -= StopCapturing;
    }

    public override void Captured(GameData.Team team)
    {
        base.Captured(team);
        StartCoroutine(ReactivateTower());
    }

    IEnumerator ReactivateTower()
    {
        yield return new WaitForSeconds(unlockTime);

        base.Unlock();
    }


}
