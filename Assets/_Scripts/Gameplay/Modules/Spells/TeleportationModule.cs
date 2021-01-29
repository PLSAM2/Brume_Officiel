using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportationModule : SpellModule
{
    public List<GameObject> onTpDisabled = new List<GameObject>();
    public Transform wxTfs;
    public PlayerModule playerModule;
    public float tpMaxTIme = 5;
    public int integibleLayer = 0;
    private bool isTping = false;
    private float timer = 0;

    private Vector3 newPos = Vector3.zero;

    private void Update()
    {
        if (isTping)
        {
            timer -= Time.deltaTime;
            UiManager.Instance.tpFillImage.fillAmount = timer / tpMaxTIme;
            if (timer <= 0)
            {
                Tp(true);
            }


            if (Input.GetMouseButtonDown(0))
            {
                if (CheckCanTp())
                {
                    Tp(false);
                }

            }
        }
    }

    private bool CheckCanTp()
    {
        return false;
    }

    protected override void Resolution()
    {
        base.Resolution();

        ushort? wxId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, GameData.Character.WuXin);

        if (wxId != null)
        {
            wxTfs = GameManager.Instance.networkPlayers[(ushort)wxId].transform;

            SetTpState(false);
        }
    }

    public void Tp(bool isTimeEnded)
    {
        if (isTimeEnded)
        {
            this.transform.position = wxTfs.position;
        } else
        {
            this.transform.position = newPos;
        }

        SetTpState(true);
    }

    // false = ON TP
    public void SetTpState(bool v)
    {
        isTping = !v;
        UiManager.Instance.tpFillImage.gameObject.SetActive(!v);

        if (v == false)
        {
            timer = tpMaxTIme;
            CameraManager.Instance.SetParent(wxTfs);
            playerModule.AddState(En_CharacterState.Stunned);
        }
        else
        {
            timer = 0;
            CameraManager.Instance.SetParent(this.transform);
            playerModule.RemoveState(En_CharacterState.Stunned);
        }

        foreach (GameObject obj in onTpDisabled)
        {
            obj.SetActive(v);
        }
    }
}
