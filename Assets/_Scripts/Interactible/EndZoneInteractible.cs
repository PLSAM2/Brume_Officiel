using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class EndZoneInteractible : Interactible
{

    [SerializeField] GameObject waypointEndZonePrefab;
    Waypoint waypointObj;
    [SerializeField] Animator endZoneAnimator;
    [SerializeField] AudioClip altarBottomAscencion, altarRightAscencion, altarLeftAscencion;
    public SpriteRenderer endZoneMapIcon;

    public bool timerElapsed = false;
    protected override void Init()
    {
        fillImg.material.SetFloat(progressShaderName, 1);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0f);
    }
    protected override void Capture()
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerCharacter != Character.WuXin)
        {
            return;
        }

        if (!timerElapsed)
        {
            if (lastTeamCaptured != NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                return;
            }
        }

        if (playerInZone.Count > 0 && playerInZone.ElementAt(0).Value != null && playerInZone.ElementAt(0).Value.teamIndex != NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }


        base.Capture();
    }

    private void Update()
    {
        if (state == State.Capturable)
        {
            if (capturingPlayerModule != null && timerElapsed)
            {
                Color t = GameFactory.GetRelativeColor(capturingPlayerModule.teamIndex);
                UiManager.Instance.endZoneUIGroup.endZoneBar.color = t;
                UiManager.Instance.endZoneUIGroup.EndZoneText.color = t;

                waypointObj.SetImageColor(t);

                t.a = UiManager.Instance.endZoneUIGroup.endZoneBarBackground.color.a;
                UiManager.Instance.endZoneUIGroup.endZoneBarBackground.color = t;
            }


            UiManager.Instance.endZoneUIGroup.endZoneBar.fillAmount = (timer / interactTime);
        }

    }

    protected override void PlayerInContestedZoneQuit(PlayerModule p)
    {

        PlayerData pd = RoomManager.Instance.GetPlayerData(p.mylocalPlayer.myPlayerId);


        if (pd.playerCharacter != Character.WuXin)
        {
            return;
        }

        if (timerElapsed)
        {
            StopCapturing();
        }
        else
        {
            if (pd.playerTeam == lastTeamCaptured)
            {
                StopCapturing();
            }
        }

        base.PlayerInContestedZoneQuit(p);
    }
    protected override void OnVolumeChange(float _value)
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerCharacter != Character.WuXin)
        {
            return;
        }

        base.OnVolumeChange(_value);
    }

    protected override void StartAudio()
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerCharacter != Character.WuXin)
        {
            return;
        }


        base.StartAudio();
    }
    public override void Unlock()
    {
        endZoneAnimator.SetTrigger("Unlock");
        endZoneMapIcon.gameObject.SetActive(true);
        UiManager.Instance.myAnnoncement.ShowAnnoncement((interactibleName + " Started").ToUpper());

        waypointObj = Instantiate(waypointEndZonePrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.target = transform;
        waypointObj.SetImageColor(Color.red);

        base.Unlock();
    }

    protected override void SetColorByState()
    {
        if (timerElapsed)
        {
            switch (state)
            {
                case State.Capturable:
                    SetColor(GameFactory.GetRelativeColor(lastTeamCaptured));
                    break;
                default:
                    break;
            }
        } else
        {
            SetColor(GameFactory.GetRelativeColor(lastTeamCaptured));
        }

    }

    internal void TimerElapsed()
    {
        waypointObj.SetImageColor(GameFactory.GetRelativeColor(lastTeamCaptured));
        CheckOnUnlock = true;
        timerElapsed = true;
    }
}
