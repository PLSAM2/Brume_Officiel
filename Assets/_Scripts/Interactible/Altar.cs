
using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;



public class Altar : Interactible
{
    [Header("Altar properties")]
    public int life;
    public float unlockTime;
    public string altarName = "";

    void Start()
    {
        base.Init();
        isInteractable = false;
    }

    public override void UpdateCaptured(Team team)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        base.UpdateCaptured(team);

        // Detruire ici
    }

    public override void Captured(Team team)
    {
        base.Captured(team);
        UiManager.Instance.DisplayGeneralMessage("Altar captured");
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
        yield return new WaitForSeconds(unlockTime);
        UiManager.Instance.DisplayGeneralMessage("Altar unlock");
        base.Unlock();
    }




}
