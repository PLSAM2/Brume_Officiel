
using DarkRift;
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

    [SerializeField] GameObject waypointAltarPrefab;
    Waypoint waypointObj;

    [SerializeField] Lava myLava;
    void Start()
    {
        base.Init();
        isInteractable = false;
    }

    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        base.UpdateCaptured(_capturingPlayerID);

        UiManager.Instance.DisplayGeneralMessage("Altar captured");

        AudioManager.Instance.Play2DAudio(capturedAltarSfx);

        if (waypointObj)
        {
            Destroy(waypointObj.gameObject);
        }

        myLava.Spawn();
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
        UiManager.Instance.DisplayGeneralMessage("Altar " + interactibleName + " unlock in " + unlockTime + " seconds");
        UiManager.Instance.UnlockNewAltar(this);
        if (value)
        {
            StartCoroutine(ActivateAltar());
        }

        if (waypointObj)
        {
            Destroy(waypointObj.gameObject);
        }

        waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.target = transform;
        waypointObj.SetImageColor(Color.gray);
    }

    IEnumerator ActivateAltar()
    {
        AudioManager.Instance.Play2DAudio(annoncementAltarSfx);
        mapIcon.sprite = willUnlockSprite;
        yield return new WaitForSeconds(unlockTime);

        UiManager.Instance.DisplayGeneralMessage("Altar unlock");
        Unlock();
    }

	public override void Unlock ()
	{
        UiManager.Instance.chat.ReceiveNewMessage(interactibleName + " Unlock", 0, true);

        mapIcon.sprite = unlockedAltar;
        base.Unlock();

        AudioManager.Instance.Play2DAudio(unlockAltarSfx);

        waypointObj.SetImageColor(Color.white);
    }
}
