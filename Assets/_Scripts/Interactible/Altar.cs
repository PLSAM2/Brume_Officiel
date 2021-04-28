
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

    [SerializeField] AudioClip unlockAltarSfx;
    [SerializeField] AudioClip capturedAltarSfx;
    [SerializeField] Sprite willUnlockSprite;

    [HideInInspector] public float currentTime = 0;

    [SerializeField] protected MeshRenderer completeObj;
    [SerializeField] protected Animator anim;
    [SerializeField] protected string colorShader = "_Color";
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

        completeObj.material.SetColor(colorShader, Color.white);
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

        if (NetworkManager.Instance.GetLocalPlayer().ID != _capturingPlayerID)
        {
            anim.SetTrigger("Captured");
            completeObj.material.SetColor(colorShader, GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam));
            completeObj.gameObject.SetActive(true);
        }
        base.UpdateCaptured(_capturingPlayerID);

        print(_capturingPlayerID + " --- " + RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam + " ---- " + RoomManager.Instance.GetPlayerData(_capturingPlayerID).Name);


        //disable
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);

        if (RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.blue) + ">YOUR TEAM </color>", capturedAltarSfx);
        }
        else
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.red) + ">ENEMY TEAM </color>", capturedAltarSfx);
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

        if (interactibleName == "Right") // BERK MAIS OSEF
        {
            UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTARS UNSEALED", unlockAltarSfx);
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

        waypointObj.SetImageColor(altarUnlockColor);
    }

    internal void StarFinalPhase()
    {
        waypointObj.gameObject.SetActive(false);
    }
}
