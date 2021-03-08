using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndZoneInteractible : Interactible
{

    [SerializeField] GameObject waypointEndZonePrefab;
    Waypoint waypointObj;

    private Altar parentAltar;

    public void Init(Altar alt)
    {
        parentAltar = alt;
    }
    protected override void Capture()
    {
        if (parentAltar.lastTeamCaptured == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }

        base.Capture();
    }

    public override void Unlock()
    {
        UiManager.Instance.myAnnoncement.AltarEndAnnoncement((interactibleName + " of Altar " + parentAltar.interactibleName + " Started").ToUpper(), parentAltar);

        waypointObj = Instantiate(waypointEndZonePrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.target = transform;
        waypointObj.SetImageColor(Color.red);

        base.Unlock();
    }
}
