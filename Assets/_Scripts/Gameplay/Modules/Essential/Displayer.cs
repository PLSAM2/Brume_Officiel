using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static FieldOfView;

public class Displayer : MonoBehaviour
{
    private void OnEnable()
    {
        GameManager.Instance.visiblePlayer.Clear();

        GameManager.Instance.OnTowerTeamCaptured += OnTowerCaptured;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnTowerTeamCaptured -= OnTowerCaptured;
    }

    // Update is called once per frame
    void Update()
    {
        LocalPlayer currentFollowPlayer = GameFactory.GetActualPlayerFollow();

        if (currentFollowPlayer != null && currentFollowPlayer.myPlayerModule.isInGhost)
        {
            if (GameManager.Instance.currentLocalGhost.isInBrume)
            {
                SetFow(currentFollowPlayer, false);
            }
            else
            {
                if (currentFollowPlayer.myPlayerModule.isInBrume)
                {
                    SetFow(currentFollowPlayer, false);
                }else
                {
                    SetFow(currentFollowPlayer, true);
                }
            }
        }

        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (currentFollowPlayer == null)
            {
                HideOrShow(player.Value, false);
                SetFow(player.Value, false);
                continue;
            }

            if (player.Value.myPlayerModule.state.HasFlag(En_CharacterState.Hidden))
            {
                if(player.Value.myPlayerModule.teamIndex != NetworkManager.Instance.GetLocalPlayer().playerTeam)
                {
                    HideOrShow(player.Value, false);
                    continue;
                }
            }

            //InGhost
            if (currentFollowPlayer == player.Value && currentFollowPlayer.myPlayerModule.isInGhost)
            {
                HideOrShow(player.Value, GameManager.Instance.visiblePlayer.ContainsKey(player.Value.transform));
                continue;
            }

            if (currentFollowPlayer == player.Value && !currentFollowPlayer.myPlayerModule.isInGhost) {
                HideOrShow(player.Value, true);
                SetFow(player.Value, true);
                continue;
            }

            if (player.Value.forceOutline)
            {
                if (GameManager.Instance.visiblePlayer.ContainsKey(player.Value.transform))
                {
                    HideOrShow(player.Value, true);
                }
                else
                {
                    SetFow(player.Value, false);
                    ShowOutline(player.Value);
                }
                continue;
            }

            if (currentFollowPlayer.myPlayerModule.isInBrume)
            {
                SetFow(player.Value, false);
                if (GameFactory.PlayersAreOnSameBrume(player.Value.myPlayerModule, currentFollowPlayer.myPlayerModule))
                {
                    if (GameManager.Instance.visiblePlayer.ContainsKey(player.Value.transform))
                    {
                        HideOrShow(player.Value, true);
                    }
                    else
                    {
                        HideOrShow(player.Value, false);
                    }
                }
                else
                {
                    HideOrShow(player.Value, false);
                }
            }
            else
            {
                if (player.Value.myPlayerModule.isInBrume)
                {
                    SetFow(player.Value, false);

                    if (GameManager.Instance.visiblePlayer.ContainsKey(player.Value.transform) && 
                        GameManager.Instance.visiblePlayer[player.Value.transform] == fowType.ward)
                    {
                        ShowOutline(player.Value);
                        continue;
                    }
                    else
                    {
                        HideOrShow(player.Value, false);
                    }
                }
                else
                {
                    if (player.Value.myPlayerModule.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
                    {
                        HideOrShow(player.Value, true);
                        SetFow(player.Value, true);
                        continue;
                    }

                    if (GameManager.Instance.visiblePlayer.ContainsKey(player.Value.transform))
                    {
                        HideOrShow(player.Value, true);
                    }
                    else
                    {
                        HideOrShow(player.Value, false);
                    }
                }
            }
        }

        DisplayFX();
    }

    void DisplayFX()
    {
        foreach(Fx fx in GameManager.Instance.allFx)
        {
            if(GameManager.Instance.allVisibleFx.Contains(fx.transform))
            {
                if (!fx.isVisible)
                {
                    fx.isVisible = true;

                    foreach (GameObject obj in fx.objToHide)
                    {
                        if (!obj) { continue; }
                        obj.SetActive(true);
                    }
                }
            }
            else
            {
                if (fx.isVisible)
                {
                    fx.isVisible = false;

                    foreach (GameObject obj in fx.objToHide)
                    {
                        if (!obj) { continue; }
                        obj.SetActive(false);
                    }
                }
            }
        }
    }

    void HideOrShow(LocalPlayer p, bool _value)
    {
        if (p.myOutline.enabled)
        {
            p.myOutline.enabled = false;
            p.canvas.SetActive(_value);
        }

        if (p.isVisible != _value)
        {
            print(p);
            p.isVisible = _value;
            foreach (GameObject obj in p.objToHide)
            {
                obj.SetActive(_value);
            }
            p.canvas.SetActive(_value);

            GameManager.Instance.OnPlayerAtViewChange?.Invoke(p.myPlayerId, _value);
        }
    }

    void SetFow(LocalPlayer p, bool _value)
    {
        p.ShowHideFow(_value);
    }


    void ShowOutline(LocalPlayer p)
    {
        p.isVisible = true;

        foreach (GameObject obj in p.objToHide)
        {
            obj.SetActive(true);
        }
        p.canvas.SetActive(false);

        if (!p.myOutline.enabled)
        {
            p.myOutline.enabled = true;
        }

        p.ShowHideFow(true);

        GameManager.Instance.OnPlayerAtViewChange?.Invoke(p.myPlayerId, true);
    }

    void OnTowerCaptured(VisionTower _tower)
    {
        LocalPlayer currentFollowPlayer = GameFactory.GetActualPlayerFollow();
        if (currentFollowPlayer == null || currentFollowPlayer.myPlayerModule.isInBrume)
        {
            _tower.vision.gameObject.SetActive(false);
        }
    }
}
