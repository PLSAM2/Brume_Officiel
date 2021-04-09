
using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
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

    [SerializeField] AudioClip annoncementAltarSfx;
    [SerializeField] AudioClip unlockAltarSfx;
    [SerializeField] AudioClip capturedAltarSfx;
    [SerializeField] Sprite willUnlockSprite;

    [HideInInspector] public float currentTime = 0;

    [SerializeField] AudioClip altarBottomCleaned, altarBottomAwakens, altarBottomUnsealed;
    [SerializeField] AudioClip altarRightCleaned, altarRightAwakens, altarRightUnsealed;
    [SerializeField] AudioClip altarLeftCleaned, altarLeftAwakens, altarLeftUnsealed;


    //wayPoint
    [SerializeField] GameObject waypointAltarPrefab;
    public Waypoint waypointObj;

    [SerializeField] Color altarLockColor;
    [SerializeField] Color altarUnlockColor;
    [SerializeField] Color altarEndColor;

    void Start()
    {
        base.Init();
        isInteractable = false;

        waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
        waypointObj.target = transform;

        GameManager.Instance.allAltar.Add(this);
    }

    private void Update()
    {
        //TODO afficher timer altar
        if (waypointObj != null && waypointObj.gameObject.activeSelf)
        {
            float currentTimeLeft = unlockTime - (Time.fixedTime - currentTime);
            if (currentTimeLeft > 0)
            {
                waypointObj.SetUnderText(Mathf.RoundToInt(currentTimeLeft) + "s");
            }
            else
            {
                waypointObj.SetUnderText("");
            }
        }
    }

    public override void TryCapture(Team team, PlayerModule capturingPlayer)
    {
        base.TryCapture(team, capturingPlayer);
    }
    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        base.UpdateCaptured(_capturingPlayerID);

        print(_capturingPlayerID + " --- " + RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam + " ---- " + RoomManager.Instance.GetPlayerData(_capturingPlayerID).Name);

        AudioClip voice = altarBottomCleaned;

        //disable
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);

        switch (interactibleName)
        {
           case "Right":
                voice = altarRightCleaned;
                break;

            case "Left":
                voice = altarLeftCleaned;
                break;
        }

        if (RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.blue) + ">YOUR TEAM </color>", capturedAltarSfx, voice);
        }
        else
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.red) + ">ENEMY TEAM </color>", capturedAltarSfx, voice);
        }

        UiManager.Instance.OnAltarUnlock(this ,RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam);

        StatManager.Instance.AddAltarEvent(altarEvent.state.CLEANSED, interactibleName, RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam);
    }

    public override void Captured(ushort _capturingPlayerID)
    {
        if (altarBuff != null)
        {
            altarBuff.InitBuff(capturingPlayerModule);
        }

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)capturingPlayerModule.teamIndex);
            writer.Write(ultimateStackGive);

            using (Message message = Message.Create(Tags.AddUltimatePointToAllTeam, writer))
            {
               NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
            }
        }

        base.Captured(_capturingPlayerID);
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
        currentTime = Time.fixedTime;

        yield return new WaitForSeconds(unlockTime);

        //AudioClip voice = altarBottomUnsealed;

        //switch (interactibleName)
        //{
        //    case "Right":
        //        voice = altarRightUnsealed;
        //        break;

        //    case "Left":
        //        voice = altarLeftUnsealed;
        //        break;
        //}

        if (interactibleName == "Right") // BERK MAIS OSEF
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTARS UNSEALED", annoncementAltarSfx);
            StatManager.Instance.AddAltarEvent(altarEvent.state.UNSEALED, "");
        }
        Unlock();
    }

	public override void Unlock ()
	{
        fillImg.gameObject.SetActive(true);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0.1f);

        mapIcon.sprite = unlockedAltar;
        base.Unlock();



        AudioManager.Instance.Play2DAudio(unlockAltarSfx);

        waypointObj.SetImageColor(altarUnlockColor);
    }

    internal void StarFinalPhase()
    {
        waypointObj.gameObject.SetActive(false);
    }
}
