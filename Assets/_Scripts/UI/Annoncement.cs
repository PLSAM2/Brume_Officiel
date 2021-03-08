using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Annoncement : MonoBehaviour
{
    [SerializeField] Animator myAnimator;
    [SerializeField] TextMeshProUGUI text;

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

    }

    public void NewAltarAnnoncement(string _value, Altar _altar) {
        text.text = _value;
        myAnimator.SetTrigger("Show");

        waypointObj.gameObject.SetActive(true);

        currentAltar = _altar;
    }

    public void ShowAnnoncement(string _value)
    {
        text.text = _value;
        myAnimator.SetTrigger("Show");
    }
}
