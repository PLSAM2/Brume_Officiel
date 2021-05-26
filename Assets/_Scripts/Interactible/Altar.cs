
using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class Altar : Interactible
{
    [SerializeField] Sprite unlockedAltar;

    [Header("Altar properties")]
    public int life;
    public float unlockTime;
    public AltarBuff altarBuff;
    public ushort ultimateStackGive = 2;
    public AltarUiProgressCollider altarUiProgressCol;

    [SerializeField] AudioClip unlockAltarSfx;
    [SerializeField] AudioClip capturedAltarSfx;
    [SerializeField] Sprite willUnlockSprite;

    [HideInInspector] public float currentTime = 0;

    [SerializeField] protected MeshRenderer completeObj;
    [SerializeField] protected Animator anim;
    [SerializeField] protected string colorShader = "_Color";
    //wayPoint
    [SerializeField] GameObject waypointAltarPrefab;
    public AltarWaypoint waypointObj;

    [SerializeField] Color altarLockColor;
    [SerializeField] Color altarUnlockColor;
    [SerializeField] Color altarEndColor;

    public GameObject redTaken, blueTaken;

    void Start()
    {
        base.Init();
        isInteractable = false;

        waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<AltarWaypoint>();
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
        waypointObj.target = transform;

        completeObj.material.SetColor(colorShader, Color.white);
        GameManager.Instance.allAltar.Add(this);

        waypointObj.SetLockStatut(true);
    }

    private void Update()
    {
        //TODO afficher timer altar
        if (waypointObj != null && waypointObj.gameObject.activeSelf)
        {
            if (currentTime > 0)
            {
                waypointObj.SetUnderText("Unlock in " + Mathf.RoundToInt(currentTime) + "s");
            }
            else
            {
                waypointObj.SetUnderText("");
            }

            currentTime -= Time.deltaTime;
        }
        else
        {
            waypointObj.SetUnderText("");
        }
    }

    public override void TryCapture(Team team, PlayerModule capturingPlayer)
    {
        base.TryCapture(team, capturingPlayer);
    }
    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant

        if (NetworkManager.Instance.GetLocalPlayer().ID != _capturingPlayerID)
        {
            anim.SetTrigger("Captured");
            completeObj.material.SetColor(colorShader, GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam));
            completeObj.gameObject.SetActive(true);
        }
        else
        {
            PlayerPrefs.SetInt("CaptureNbr", PlayerPrefs.GetInt("CaptureNbr") + 1);
        }
        base.UpdateCaptured(_capturingPlayerID);


        //disable
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);

        if (RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            blueTaken.SetActive(true);
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.blue) + ">YOUR TEAM </color>", capturedAltarSfx);
        }
        else
        {
            redTaken.SetActive(true);
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.red) + ">ENEMY TEAM </color>", capturedAltarSfx);
        }

        UiManager.Instance.OnAltarUnlock(this, RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam);

        StatManager.Instance.AddAltarEvent(altarEvent.state.CLEANSED, interactibleName, RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam);
    }

    public override void Captured(ushort _capturingPlayerID)
    {
        if (altarBuff != null)
        {
            altarBuff.InitBuff(capturingPlayerModule);
        }

        anim.SetTrigger("Captured");
        completeObj.material.SetColor(colorShader, GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam));
        completeObj.gameObject.SetActive(true);

        /*
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)capturingPlayerModule.teamIndex);
            writer.Write(ultimateStackGive);

            using (Message message = Message.Create(Tags.AddUltimatePointToAllTeam, writer))
            {
               NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
            }
        }
*/
        if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(capturingPlayerModule.teamIndex))
        {
            GameManager.Instance.numberOfAltarControled++;
        }
        else
            GameManager.Instance.numberOfAltarControledByEnemy++;


        base.Captured(_capturingPlayerID);
    }

    public override void UpdateTryCapture(ushort _capturingPlayerID)
    {
        base.UpdateTryCapture(_capturingPlayerID);
    }


    public override void SetActiveState(bool value)
    {
        base.SetActiveState(value);
        UiManager.Instance.UnlockNewAltar(this);
        if (value)
        {
            StartCoroutine(ActivateAltar());
        }
    }

    IEnumerator ActivateAltar()
    {
        mapIcon.sprite = willUnlockSprite;
        
        if (RoomManager.Instance.roundCount == 1)
        {
            currentTime = unlockTime + GameManager.Instance.trainTimer;
        }
        else
        {
            currentTime = unlockTime;
        }

        yield return new WaitForSeconds(currentTime);



        if (interactibleName == "Right") // BERK MAIS OSEF
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTARS UNSEALED", unlockAltarSfx);
            StatManager.Instance.AddAltarEvent(altarEvent.state.UNSEALED, "");
        }
        Unlock();
    }

    public override void Unlock()
    {
        fillImg.gameObject.SetActive(true);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0.1f);

        mapIcon.sprite = unlockedAltar;
        base.Unlock();

        waypointObj.SetImageColor(altarUnlockColor);

        waypointObj.SetLockStatut(false);
    }

    internal void StarFinalPhase()
    {
        waypointObj.gameObject.SetActive(false);
    }


    public void OnPlayerDie(ushort deadP)
    {


        PlayerModule pm = altarUiProgressCol.playerInUIZone.Where(x => x.mylocalPlayer.myPlayerId == deadP).FirstOrDefault();

        if (pm != null)
        {
            altarUiProgressCol.playerInUIZone.Remove(pm);
        }

        pm = playerInZone.Where(x => x.mylocalPlayer.myPlayerId == deadP).FirstOrDefault();

        if (pm != null)
        {
            playerInZone.Remove(pm);
        }

        playerInZone.RemoveAll(item => item == null);
        altarUiProgressCol.playerInUIZone.RemoveAll(item => item == null);

        UpdateUI();
    }

    public override void UpdateUI()
    {
        base.UpdateUI();


        if (!altarUiProgressCol.IsplayerInUIZoneContainLocalPlayer())
        {
            return;
        }

        if (state != State.Capturable)
        {
            UiManager.Instance.SetAltarCaptureUIState(false);
            return;
        }

        if (GetLocalPlayerCountInZone() <= 0)
        {
            UiManager.Instance.SetAltarCaptureUIState(false);
            return;
        }

        if (IsLocallyContested())
        {
            UiManager.Instance.SetAltarCaptureUIState(true, true);
        }
        else
        {
            if (playerInZone[0].teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                UiManager.Instance.SetAltarCaptureUIState(true, false, GetLocalPlayerCountInZone());
            }
            else
            {

                UiManager.Instance.SetAltarCaptureUIState(false);
            }
        }
    }
}
