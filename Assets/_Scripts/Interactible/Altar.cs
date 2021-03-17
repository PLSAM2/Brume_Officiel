
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

    public EndZoneInteractible endZoneInteractible;
    [SerializeField] AudioClip annoncementAltarSfx;
    [SerializeField] AudioClip unlockAltarSfx;
    [SerializeField] AudioClip capturedAltarSfx;
    [SerializeField] Sprite willUnlockSprite;

    [HideInInspector] public float currentTime = 0;

    [SerializeField] AudioClip altarBottomCleaned, altarBottomAwakens, altarBottomUnsealed;
    [SerializeField] AudioClip altarRightCleaned, altarRightAwakens, altarRightUnsealed;
    [SerializeField] AudioClip altarLeftCleaned, altarLeftAwakens, altarLeftUnsealed;
    void Start()
    {
        base.Init();
        endZoneInteractible.Init(this);
        isInteractable = false;
    }

    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        base.UpdateCaptured(_capturingPlayerID);

        AudioClip voice = altarBottomCleaned;
        UiManager.Instance.myAnnoncement.DisableAltar();

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

        AudioClip voice = altarBottomAwakens;

        switch (interactibleName)
        {
            case "Right":
                voice = altarRightAwakens;
                break;

            case "Left":
                voice = altarLeftAwakens;
                break;
        }

        UiManager.Instance.myAnnoncement.NewAltarAnnoncement((interactibleName + " ALTAR AWAKENS").ToUpper(), this, null, voice);
    }

    IEnumerator ActivateAltar()
    {
        mapIcon.sprite = willUnlockSprite;
        currentTime = Time.fixedTime;

        yield return new WaitForSeconds(unlockTime);

        AudioClip voice = altarBottomUnsealed;

        switch (interactibleName)
        {
            case "Right":
                voice = altarRightUnsealed;
                break;

            case "Left":
                voice = altarLeftUnsealed;
                break;
        }

        UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR UNSEALED", annoncementAltarSfx, voice);
        Unlock();
    }

	public override void Unlock ()
	{
        fillImg.gameObject.SetActive(true);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0.1f);

        mapIcon.sprite = unlockedAltar;
        base.Unlock();

        AudioManager.Instance.Play2DAudio(unlockAltarSfx);

        UiManager.Instance.myAnnoncement.SetUnlockAltar();
    }

    internal void StarFinalPhase()
    {
        endZoneInteractible.gameObject.SetActive(true);
        endZoneInteractible.Unlock();
        fillImg.gameObject.SetActive(false);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0);
    }
}
