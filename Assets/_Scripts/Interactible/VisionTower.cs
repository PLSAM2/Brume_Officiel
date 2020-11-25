using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisionTower : Interactible
{
    [Header("Vision Tower properties")]
    public Fow vision;

    [Header("Tower Special Map")]
    public SpriteRenderer towerBody;
    public Sprite capturableState, lockedState;

    void Start()
    {
        base.Init();
        towerBody.sprite = lockedState;
    }

    public override void Captured(GameData.Team team)
    {
        base.Captured(team);
        towerBody.sprite = lockedState;
    }

    public override void Unlock()
    {
        base.Unlock();
        towerBody.sprite = capturableState;
    }

    public override void UpdateCaptured(GameData.Team team)
    {
        base.UpdateCaptured(team);

        if (team == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            vision.gameObject.SetActive(true);
            vision.Init();

            GameManager.Instance.allTower.Add(this);
            GameManager.Instance.OnTowerTeamCaptured?.Invoke(this);
        }
        else
        {
            vision.gameObject.SetActive(false);
        }
    }

    public void ReactivateTower()
    {
        Unlock();
    }
}
