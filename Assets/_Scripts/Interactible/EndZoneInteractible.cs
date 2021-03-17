using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class EndZoneInteractible : Interactible
{

    [SerializeField] GameObject waypointEndZonePrefab;
    Waypoint waypointObj;

    private Altar parentAltar;

    [SerializeField] AudioClip altarBottomAscencion, altarRightAscencion, altarLeftAscencion;

    public void Init(Altar alt)
    {
        parentAltar = alt; 
        fillImg.material.SetFloat(progressShaderName, 1);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0f);
    }

    public override void TryCapture(GameData.Team team, PlayerModule capturingPlayer)
    {
        if (parentAltar.lastTeamCaptured == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }

        base.TryCapture(team, capturingPlayer);
    }
    protected override void Capture()
    {
        if (parentAltar.lastTeamCaptured == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }

        base.Capture();
    }

    protected override void OnVolumeChange(float _value)
    {
        if (parentAltar.lastTeamCaptured == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }

        base.OnVolumeChange(_value);
    }
    public override void Unlock()
    {
        AudioClip voice = altarBottomAscencion;

        switch (parentAltar.interactibleName)
        {
            case "Right":
                voice = altarRightAscencion;
                break;

            case "Left":
                voice = altarLeftAscencion;
                break;
        }

        UiManager.Instance.myAnnoncement.AltarEndAnnoncement((interactibleName + " of Altar " + parentAltar.interactibleName + " Started").ToUpper(), parentAltar, null, voice);


        waypointObj = Instantiate(waypointEndZonePrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.target = transform;
        waypointObj.SetImageColor(Color.red);

        base.Unlock();
    }

    protected override void SetColorByState()
    {
        switch (state)
        {
            case State.Locked:
                break;
            case State.Capturable:
                SetColor(GameFactory.GetRelativeColor(parentAltar.lastTeamCaptured));
                break;
            case State.Captured:
                break;
            default:
                break;
        }
    }
}
