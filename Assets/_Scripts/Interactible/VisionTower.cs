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

    [SerializeField] AudioClip capturedTowerSfx;

    void Start()
    {
        base.Init();
        towerBody.sprite = lockedState;
    }

    public override void TryCapture(GameData.Team team, PlayerModule capturingPlayer)
    {
        if (capturingTeam == team)
        {
            return;
        }

        base.TryCapture(team, capturingPlayer);
    }
    public override void Captured(ushort _capturingPlayerID)
    {
        base.Captured(_capturingPlayerID);
        towerBody.sprite = lockedState;

        AudioManager.Instance.Play2DAudio(capturedTowerSfx);
    }

    public override void Unlock()
    {
        base.Unlock();
        towerBody.sprite = capturableState;
    }

    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        base.UpdateCaptured(_capturingPlayerID);

        if (RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            vision.gameObject.SetActive(true);
            vision.Init();

            //GameManager.Instance.allTower.Add(this);
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
