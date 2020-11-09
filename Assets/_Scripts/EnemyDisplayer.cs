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
        foreach (KeyValuePair<ushort, LocalPlayer> enemy in GameManager.Instance.networkPlayers)
        {
            if (enemy.Value.isOwner) { continue; }

            if(GameManager.Instance.currentLocalPlayer == null){ return; }

            if (GameManager.Instance.currentLocalPlayer.myPlayerModule.isInBrume)
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

    void HideOrShow(LocalPlayer p, bool value)
    {
        foreach(GameObject obj in p.objToHide)
        {
            obj.SetActive(value);
        }
        p.ShowHideFow(value);
    }
}
