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
    public ParticleSystem tpFx;
    public PlayerModule playerModule;
    public float tpMaxTIme = 5;
    public int integibleLayer = 16;
    public LayerMask tpLayer;
    public LayerMask raycastLayer;
    public float tpDistance = 5;
    public float waitForTpTime = 2;

    private bool isWaitingForTp = false;
    private bool isTping = false;
    private float timer = 0;
    private Vector3 newPos = Vector3.zero;
    private Ray ray;
    private RaycastHit hit;




    private void Update()
    {
        if (isTping)
        {
            timer -= Time.deltaTime;
            UiManager.Instance.tpFillImage.fillAmount = timer / tpMaxTIme;

            if (timer <= 0)
            {
                if (!isWaitingForTp)
                {
                    Tp(true);
                }
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
        if (isWaitingForTp)
        {
            return false;
        }

        ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Vector3 _pos = Vector3.zero;
        if (Physics.Raycast(ray, out hit,300, raycastLayer))
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
        if (isTping)
        {
            return;
        }

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
        if (!isWaitingForTp)
        {
            StartCoroutine(WaitForSpawn(isTimeEnded));
        }

    }

    // false = ON TP
    public void SetTpState(bool v)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(v);

            if (v)
            {
                _writer.Write(newPos.x);
                _writer.Write(newPos.z);
            }

            using (Message _message = Message.Create(Tags.Tp, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }

        foreach (Interactible inter in playerModule.interactiblesClose)
        {
            inter.StopCapturing();

        }
        playerModule.interactiblesClose.Clear();
        wxController.DisplayTpZone(!v);
        UiManager.Instance.tpFillImage.gameObject.SetActive(!v);
        isTping = !v;


        if (v == false) // SI TP
        {
            this.gameObject.layer = integibleLayer;
            timer = tpMaxTIme;
            CameraManager.Instance.SetParent(wxTfs);
            playerModule.AddState(En_CharacterState.Stunned);
        }
        else // sinon
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

    public void SetTpStateInServer(bool v, Vector3 _newPos)
    {
        if (v)
        {
            print(_newPos);
            this.transform.position = _newPos;
        }

        foreach (Interactible inter in playerModule.interactiblesClose)
        {
            inter.StopCapturing();

        }
        playerModule.interactiblesClose.Clear();

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

    public IEnumerator WaitForSpawn(bool isTimeEnded) 
    {
        isWaitingForTp = true;

        foreach (Interactible inter in playerModule.interactiblesClose)
        {
            inter.StopCapturing();

        }
        playerModule.interactiblesClose.Clear();


        wxController.DisplayTpZone(false);
        UiManager.Instance.tpFillImage.gameObject.SetActive(false);

        yield return new WaitForSeconds(waitForTpTime);

        if (isTimeEnded)
        {
            this.transform.position = wxTfs.position;
        }
        else
        {
            this.transform.position = newPos;
        }


        SetTpState(true);

        isWaitingForTp = false;
    }
}
