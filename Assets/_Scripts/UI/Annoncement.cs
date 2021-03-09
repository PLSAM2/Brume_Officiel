using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Annoncement : MonoBehaviour
{
    [SerializeField] Animator myAnimator;
    [SerializeField] TextMeshProUGUI text;
    [SerializeField] RectTransform iconPos;

    [SerializeField] GameObject waypointAltarPrefab;
    Waypoint waypointObj;
    Altar currentAltar;

    [SerializeField] Color altarLockColor;
    [SerializeField] Color altarUnlockColor;
    [SerializeField] Color altarEndColor;

    private void Start()
    {
        waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
    }

    private void Update()
    {
        //TODO afficher timer altar
        if(currentAltar != null)
        {
            float currentTimeLeft = currentAltar.unlockTime -  (Time.fixedTime - currentAltar.currentTime);
            if(currentTimeLeft > 0)
            {
                waypointObj.SetUnderText(Mathf.RoundToInt(currentTimeLeft) + "s");
            }
            else
            {
                waypointObj.SetUnderText("");
            }
        }
    }

    public void SetUnlockAltar()
    {
        waypointObj.SetImageColor(altarUnlockColor);
    }

    public void DisableAltar()
    {
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
    }

    public void AltarEndAnnoncement(string _value, Altar _altar)
    {
        text.text = _value;
        myAnimator.SetTrigger("Show");

        waypointObj.SetImageColor(altarEndColor);

        waypointObj.target = _altar.transform;

        waypointObj.gameObject.SetActive(true);
        waypointObj.ActiveAnnonciation(iconPos);

        currentAltar = _altar;
    }

    public void NewAltarAnnoncement(string _value, Altar _altar) {
        text.text = _value;
        myAnimator.SetTrigger("Show");

        waypointObj.target = _altar.transform;

        waypointObj.gameObject.SetActive(true);
        waypointObj.ActiveAnnonciation(iconPos);


        currentAltar = _altar;
    }

    public void ShowAnnoncement(string _value)
    {
        text.text = _value;
        myAnimator.SetTrigger("Show");
    }
}
