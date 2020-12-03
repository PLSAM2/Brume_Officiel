
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
    public string altarName = "";
    public AltarBuff altarBuff;

    [SerializeField] AudioClip annoncementAltarSfx;
    [SerializeField] AudioClip unlockAltarSfx;
    [SerializeField] AudioClip capturedAltarSfx;

    void Start()
    {
        base.Init();
        isInteractable = false;
    }

    public override void UpdateCaptured(Team team)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        base.UpdateCaptured(team);

        UiManager.Instance.DisplayGeneralMessage("Altar captured");

        AudioManager.Instance.Play2DAudio(capturedAltarSfx);
    }

    public override void Captured(Team team)
    {
        altarBuff.InitBuff(capturingPlayerModule);
        base.Captured(team);
    }
    public override void SetActiveState(bool value)
    {
        base.SetActiveState(value);
        UiManager.Instance.DisplayGeneralMessage("Altar " + altarName + " unlock in " + unlockTime + " seconds");
        if (value)
        {
            StartCoroutine(ActivateAltar());
        }
    }

    IEnumerator ActivateAltar()
    {
        AudioManager.Instance.Play2DAudio(annoncementAltarSfx);

        yield return new WaitForSeconds(unlockTime);

        UiManager.Instance.DisplayGeneralMessage("Altar unlock");
        Unlock();
    }

	public override void Unlock ()
	{
        mapIcon.sprite = unlockedAltar;
        base.Unlock();

        AudioManager.Instance.Play2DAudio(unlockAltarSfx);
    }
}
