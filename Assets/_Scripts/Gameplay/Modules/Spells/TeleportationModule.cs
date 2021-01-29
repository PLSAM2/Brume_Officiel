using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportationModule : SpellModule
{
    public List<GameObject> onTpDisabled = new List<GameObject>();
    public Transform wxTfs;
    public WxController wxController;

    public PlayerModule playerModule;
    public float tpMaxTIme = 5;
    public int integibleLayer = 16;
    public LayerMask tpLayer = 10;
    public float tpDistance = 5;
    private bool isTping = false;
    private float timer = 0;
    private Vector3 newPos = Vector3.zero;
    private Ray ray;
    private RaycastHit hit;


    protected override void DestroyIfClient(){}

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
        ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Vector3 _pos = Vector3.zero;
        if (Physics.Raycast(ray, out hit))
        {
            _pos = hit.point;

            if (Vector3.Distance(wxTfs.position, _pos) > tpDistance)
            {
                return false;
            }
           
            if (IsInLayer(hit.collider.gameObject.layer, tpLayer))
            {
                newPos = new Vector3(_pos.x, 0, _pos.z);
                return true;
            }
        }

        return false;
    }

    public static bool IsInLayer(int layer, LayerMask layermask)
    {
        return layermask == (layermask | (1 << layer));
    }

    protected override void Resolution()
    {
        base.Resolution();

        ushort? wxId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, GameData.Character.WuXin);

        if (wxId != null)
        {
            wxTfs = GameManager.Instance.networkPlayers[(ushort)wxId].transform;
            wxController = wxTfs.GetComponent<WxController>();
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
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(v);

            using (Message _message = Message.Create(Tags.Tp, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }


        isTping = !v;
        UiManager.Instance.tpFillImage.gameObject.SetActive(!v);
        wxController.DisplayTpZone(!v);

        if (v == false)
        {
            this.gameObject.layer = integibleLayer;
            timer = tpMaxTIme;
            CameraManager.Instance.SetParent(wxTfs);
            playerModule.AddState(En_CharacterState.Stunned);
        }
        else
        {
            timer = 0;
            playerModule.ResetLayer();
            CameraManager.Instance.SetParent(this.transform);
            playerModule.RemoveState(En_CharacterState.Stunned);
        }

        foreach (GameObject obj in onTpDisabled)
        {
            obj.SetActive(v);
        }
    }

    public void SetTpStateInServer(bool v)
    {
        if (v == false)
        {
            this.gameObject.layer = integibleLayer;
        }
        else
        {
            playerModule.ResetLayer();
        }

        foreach (GameObject obj in onTpDisabled)
        {
            obj.SetActive(v);
        }
    }
}
