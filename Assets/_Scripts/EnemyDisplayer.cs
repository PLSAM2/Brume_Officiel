using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDisplayer : MonoBehaviour
{
    private void OnEnable()
    {
        GameManager.Instance.visiblePlayer.Clear();
    }

    // Update is called once per frame
    void Update()
    {
        LocalPlayer currentFollowPlayer = null;

        if(GameManager.Instance.currentLocalPlayer != null)
        {
            currentFollowPlayer = GameManager.Instance.currentLocalPlayer;
        }
        else
        {
            currentFollowPlayer = GameManager.Instance.networkPlayers[UiManager.Instance.specMode.playerSpected];
        }

        foreach (KeyValuePair<ushort, LocalPlayer> enemy in GameManager.Instance.networkPlayers)
        {
            if (enemy.Value.isOwner) { continue; }

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
            }

            if (currentFollowPlayer.myPlayerModule.isInBrume)
            {
                if (enemy.Value.myPlayerModule.isInBrume)
                {
                    if (GameManager.Instance.visiblePlayer.Contains(enemy.Value.transform))
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
                    HideOrShow(enemy.Value, false);
                }
                else
                {
                    if (enemy.Value.myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
                    {
                        HideOrShow(enemy.Value, true);
                        continue;
                    }

                    if (GameManager.Instance.visiblePlayer.Contains(enemy.Value.transform))
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
            p.ShowHideFow(_value);

            GameManager.Instance.OnPlayerAtViewChange(p.myPlayerId, _value);
        }
    }
}
