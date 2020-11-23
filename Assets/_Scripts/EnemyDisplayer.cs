using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static FieldOfView;

public class EnemyDisplayer : MonoBehaviour
{
    private void OnEnable()
    {
        GameManager.Instance.visiblePlayer.Clear();
    }

    // Update is called once per frame
    void Update()
    {
        LocalPlayer currentFollowPlayer = GameFactory.GetActualPlayerFollow();

        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (currentFollowPlayer == player.Value) {
                HideOrShow(player.Value, true);
                SetFow(player.Value, true);
                continue;
            }

            if(currentFollowPlayer == null){
                HideOrShow(player.Value, false);
                SetFow(player.Value, false);
                continue;
            }

            if (player.Value.forceShow)
            {
                HideOrShow(player.Value, true);
                SetFow(player.Value, true);
                continue;
            }

            if (currentFollowPlayer.myPlayerModule.isInBrume)
            {
                SetFow(player.Value, false);
                if ( GameFactory.PlayersAreOnSameBrume(player.Value.myPlayerModule, currentFollowPlayer.myPlayerModule))
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
                        print("outline");
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
                        print("ici");
                    }
                    else
                    {
                        HideOrShow(player.Value, false);
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
            p.isVisible = _value;
            foreach (GameObject obj in p.objToHide)
            {
                obj.SetActive(_value);
            }
            p.canvas.SetActive(_value);

            GameManager.Instance.OnPlayerAtViewChange(p.myPlayerId, _value);
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

        GameManager.Instance.OnPlayerAtViewChange(p.myPlayerId, true);
    }
}
