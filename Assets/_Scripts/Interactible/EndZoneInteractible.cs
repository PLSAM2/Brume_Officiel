using DarkRift;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class EndZoneInteractible : Interactible
{

    [SerializeField] GameObject waypointEndZonePrefab;
    Waypoint waypointObj;

    [SerializeField] AudioClip altarBottomAscencion, altarRightAscencion, altarLeftAscencion;

    protected override void Init()
    {
        fillImg.material.SetFloat(progressShaderName, 1);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0f);
    }
    protected override void Capture()
    {
        if (lastTeamCaptured != NetworkManager.Instance.GetLocalPlayer().playerTeam || NetworkManager.Instance.GetLocalPlayer().playerCharacter != Character.WuXin)
        {
            return;
        }

        if (playerInZone.FirstOrDefault(x => x.teamIndex != NetworkManager.Instance.GetLocalPlayer().playerTeam) != null)
        {
            return;
        }

        base.Capture();
    }

    protected override void PlayerInContestedZoneQuit(PlayerModule p)
    {
        PlayerData pd = RoomManager.Instance.GetPlayerData(p.mylocalPlayer.myPlayerId);

        if (pd.playerCharacter == Character.WuXin && pd.playerTeam == lastTeamCaptured)
        {
            StopCapturing();
        }

        base.PlayerInContestedZoneQuit(p);
    }
    protected override void OnVolumeChange(float _value)
    {
        if (lastTeamCaptured != NetworkManager.Instance.GetLocalPlayer().playerTeam && NetworkManager.Instance.GetLocalPlayer().playerCharacter != Character.WuXin)
        {
            return;
        }

        base.OnVolumeChange(_value);
    }
    public override void Unlock()
    {
        UiManager.Instance.myAnnoncement.ShowAnnoncement((interactibleName + " Started").ToUpper());

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
                SetColor(GameFactory.GetRelativeColor(lastTeamCaptured));
                break;
            case State.Captured:
                break;
            default:
                break;
        }
    }
}
