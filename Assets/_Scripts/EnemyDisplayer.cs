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

        foreach (KeyValuePair<ushort, LocalPlayer> enemy in GameManager.Instance.networkPlayers)
        {
            if (currentFollowPlayer == enemy.Value) {
                HideOrShow(enemy.Value, true);
                continue;
            }

            if(currentFollowPlayer == null){
                if (enemy.Value.myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
                {
                    HideOrShow(enemy.Value, true);
                }
                else
                {
                    HideOrShow(enemy.Value, false);
                }
                continue;
            }

            if (enemy.Value.forceShow)
            {
                HideOrShow(enemy.Value, true);
                continue;
            }

            if (currentFollowPlayer.myPlayerModule.isInBrume)
            {
                if (enemy.Value.myPlayerModule.isInBrume && enemy.Value.myPlayerModule.brumeId == currentFollowPlayer.myPlayerModule.brumeId)
                {
                    if (GameManager.Instance.visiblePlayer.ContainsKey(enemy.Value.transform))
                    {
                        HideOrShow(enemy.Value, true);
                    }
                    else
                    {
                        HideOrShow(enemy.Value, false);
                    }
                }
                else
                {
                    HideOrShow(enemy.Value, false);
                }
            }
            else
            {
                if (enemy.Value.myPlayerModule.isInBrume)
                {
                    if (GameManager.Instance.visiblePlayer.ContainsKey(enemy.Value.transform) && 
                        GameManager.Instance.visiblePlayer[enemy.Value.transform] == fowType.ward)
                    {
                        ShowOutline(enemy.Value);
                        continue;
                    }
                    else
                    {
                        HideOrShow(enemy.Value, false);
                    }
                }
                else
                {
                    if (enemy.Value.myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
                    {
                        HideOrShow(enemy.Value, true);
                        continue;
                    }

                    if (GameManager.Instance.visiblePlayer.ContainsKey(enemy.Value.transform))
                    {
                        HideOrShow(enemy.Value, true);
                    }
                    else
                    {
                        HideOrShow(enemy.Value, false);
                    }
                }
            }
        }
    }

    void HideOrShow(LocalPlayer p, bool _value)
    {
        if (p.isVisible != _value)
        {
            p.isVisible = _value;
            foreach (GameObject obj in p.objToHide)
            {
                obj.SetActive(_value);
            }
            p.canvas.SetActive(_value);

            p.ShowHideFow(_value);

            if (p.myOutline.enabled)
            {
                p.myOutline.enabled = false;
            }

            GameManager.Instance.OnPlayerAtViewChange(p.myPlayerId, _value);
        }
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
