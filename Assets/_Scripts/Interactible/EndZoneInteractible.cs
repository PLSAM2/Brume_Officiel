using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndZoneInteractible : Interactible
{
    [SerializeField] GameObject waypointEndZonePrefab;
    Waypoint waypointObj;

    public override void Unlock()
    {
        waypointObj = Instantiate(waypointEndZonePrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.target = transform;
        waypointObj.SetImageColor(Color.red);

        base.Unlock();
    }
}
