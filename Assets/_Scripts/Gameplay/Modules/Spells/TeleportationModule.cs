using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class TeleportationModule : SpellModule
{
    public PlayerModule playerModule;
    public float tpMaxTime = 5;
    public int integibleLayer = 16;
    public LayerMask tpLayer;
    public LayerMask raycastLayer;
    public float tpDistance = 5;
    public float waitForTpTime = 2;

    [SerializeField] private GameObject tpFxObj;
    private CirclePreview circlePreview;
    private bool isWaitingForTp = false;
    private bool isTping = false;
    private float timer = 0;
    private Vector3 newPos = Vector3.zero;
    private Ray ray;
    private RaycastHit hit;
    private Transform wxTfs;
    private WxController wxController;
    private GameObject tpFx;

    public override void DecreaseCooldown()
    {
    }
    private void Start()
    {
        base.AddCharge();
    }

    protected override void Update() {
       base.Update();
    
        if (isTping)
        {
            timer -= Time.deltaTime;
            UiManager.Instance.tpFillImage.fillAmount = timer / tpMaxTime;

            if (timer <= 0)
            {
                if (!isWaitingForTp)
                {
                    Tp(true);
                }
            }
            if (circlePreview != null)
            {
                circlePreview.transform.position = wxTfs.position + Vector3.up * 0.1f;
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
           
            if (GameFactory.IsInLayer(hit.collider.gameObject.layer, tpLayer))
            {
                newPos = new Vector3(_pos.x, 0, _pos.z);
                return true;
            }
        }

        return false;
    }


    public void TpOnRes()
    {
        ushort? wxId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, GameData.Character.WuXin);

        if (wxId != null)
        {
            wxTfs = GameManager.Instance.networkPlayers[(ushort)wxId].transform;
            wxController = wxTfs.GetComponent<WxController>();
            SetTpState(false);
        }
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

    /// <summary>
    /// UNIQUEMENT EN LOCAL
    /// </summary>
    /// <param name="value">faux = lance le tp / se met invisble 
    /// True = se tp sur newpos</param>
    public void SetTpState(bool value, Vector3? finalPos = null )
    {
        if (finalPos != null)
        {
            newPos = (Vector3)finalPos;
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(value);

            if (value)
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
        wxController.DisplayTpZone(!value);
        UiManager.Instance.tpFillImage.gameObject.SetActive(!value);
        isTping = !value;

        if (value == false) // SI TP
        {
            this.gameObject.layer = integibleLayer;
            timer = tpMaxTime;
            playerModule.AddState(En_CharacterState.Stunned);

            //
            wxController.mylocalPlayer.forceShow = true;
            playerModule.mylocalPlayer.isTp = true;

            UiManager.Instance.specMode.ChangeSpecPlayer(wxController.mylocalPlayer.myPlayerId);
            wxController.mylocalPlayer.ShowHideFow(true);

            if (circlePreview == null)
            {
                circlePreview = PreviewManager.Instance.GetCirclePreview(wxTfs);
            }
            circlePreview.gameObject.SetActive(true);
            circlePreview.Init(tpDistance, CirclePreview.circleCenter.center, wxTfs.position + Vector3.up * 0.1f);
        }
        else // sinon
        {
            timer = 0;
            playerModule.ResetLayer();
            CameraManager.Instance.SetParent(this.transform);
            playerModule.RemoveState(En_CharacterState.Stunned);
        }

        foreach (GameObject obj in playerModule.mylocalPlayer.objToHide)
        {
            obj.SetActive(value);
        }
        playerModule.mylocalPlayer.myUiPlayerManager.canvas.SetActive(value);
        playerModule.mylocalPlayer.circleDirection.SetActive(value);
    }

    /// <summary>
    /// uniquement chez les autres
    /// </summary>
    /// <param name="_newPos">position de tp</param>
    public void SetTpStateInServer(bool value, Vector3 _newPos)
    {
        if (value)
        {
            this.transform.position = _newPos;
        }

        if (playerModule != null)
        {
            foreach (Interactible inter in playerModule.interactiblesClose)
            {
                inter.StopCapturing();
            }
            playerModule.interactiblesClose.Clear();


            if (value == false)
            {
                this.gameObject.layer = integibleLayer;
            }
            else
            {
                playerModule.ResetLayer();
            }

            foreach (GameObject obj in playerModule.mylocalPlayer.objToHide)
            {
                obj.SetActive(value);
            }
            playerModule.mylocalPlayer.myUiPlayerManager.canvas.SetActive(value);
        }

    }

    public override void ResolutionFeedBack()
    {
        base.ResolutionFeedBack();

        LocalPoolManager.Instance.SpawnNewTrailTpFX(transform.position, myPlayerModule.teamIndex);
    }

    public override void ThrowbackEndFeedBack()
    {
        base.ThrowbackEndFeedBack();
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

        if (circlePreview != null)
        {
            circlePreview.gameObject.SetActive(false);

        }

        // QUAND ON CLIQUE POUR SE TP

        Vector3 finalPos = Vector3.zero;

        if (isTimeEnded)
        {
            finalPos = wxTfs.position;        
        }
        else
        {
            finalPos = newPos;           
        }
        tpFx = NetworkObjectsManager.Instance.NetworkInstantiate(tpFxObj, finalPos);

        yield return new WaitForSeconds(waitForTpTime);

        // QUAND ON SE TP APRES LATTENTE

        wxController.mylocalPlayer.forceShow = false;
        playerModule.mylocalPlayer.isTp = false;

        CameraManager.Instance.ResetPlayerFollow();

        this.transform.position = finalPos;

        SetTpState(true, finalPos);

        isWaitingForTp = false;
    }
}
