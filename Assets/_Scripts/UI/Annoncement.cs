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


    private void Start()
    {
        waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.target = transform;
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
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

    public void NewAltarAnnoncement(string _value, Altar _altar) {
        text.text = _value;
        myAnimator.SetTrigger("Show");

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
