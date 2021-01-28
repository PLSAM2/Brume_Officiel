using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportationModule : SpellModule
{
    public List<GameObject> onTpDisabled = new List<GameObject>();
    public Transform wxTfs;

    public bool isTping = false;


    private void Update()
    {
        if (isTping)
        {
            if (Input.GetMouseButtonDown(0))
            {
                Tp();
            }
        }
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


    public void Tp()
    {
        SetTpState(true);
    }

    // false = ON TP
    public void SetTpState(bool v)
    {
        isTping = !v;

        if (v == false)
        {
            CameraManager.Instance.SetParent(wxTfs);
        } else
        {
            CameraManager.Instance.SetParent(this.transform);
        }


        foreach (GameObject obj in onTpDisabled)
        {
            obj.SetActive(v);
        }
    }
}
