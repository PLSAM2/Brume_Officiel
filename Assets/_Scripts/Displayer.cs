using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static FieldOfView;

public class Displayer : MonoBehaviour
{
    private void OnEnable()
    {
        GameManager.Instance.visiblePlayer.Clear();
    }

    // Update is called once per frame
    void Update()
    {
        LocalPlayer currentFollowPlayer = GameFactory.GetActualPlayerFollow();

        if (currentFollowPlayer != null && currentFollowPlayer.myPlayerModule.isInGhost)
        {
            if (currentFollowPlayer.myPlayerModule.isInBrume)
            {
                HideOrShow(GameManager.Instance.GetLocalPlayerObj(), false);
                SetFow(GameManager.Instance.GetLocalPlayerObj(), false);
                GameManager.Instance.GetLocalPlayerObj().circleDirection.SetActive(false);
            }
            else
            {
                HideOrShow(GameManager.Instance.GetLocalPlayerObj(), true);
                SetFow(GameManager.Instance.GetLocalPlayerObj(), true);
                GameManager.Instance.GetLocalPlayerObj().circleDirection.SetActive(true);
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
                    if (player.Value.myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
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

        //ghost
        foreach(Ghost ghost in GameManager.Instance.allGhost)
        {
            if (GameManager.Instance.visiblePlayer.ContainsKey(ghost.transform))
            {
                if (!ghost.isVisible)
                {
                    ghost.isVisible = true;
                    foreach (GameObject obj in ghost.objToHide)
                    {
                        obj.SetActive(true);
                    }
                }
            }
            else
            {
                if (ghost.isVisible)
                {
                    ghost.isVisible = false;
                    foreach (GameObject obj in ghost.objToHide)
                    {
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
            print("oui");
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
}
