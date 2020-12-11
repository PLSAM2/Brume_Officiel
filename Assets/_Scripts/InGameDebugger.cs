using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class InGameDebugger : MonoBehaviour
{
    public List<Altar> altars;
    public GameObject playerListObj;
    public GameObject RedPlayerLayout;
    public GameObject bluePlayerLayout;

    public Text fps;

    private void Awake()
    {
        Init();
    }

    private void Update()
    {
        
    }
    private void Init()
    {
        foreach (PlayerData p in RoomManager.Instance.actualRoom.playerList.Values)
        {
            switch (p.playerTeam)
            {
                case GameData.Team.none:
                    return;
                case GameData.Team.red:
                    break;
                case GameData.Team.blue:
                    break;
                default:
                    throw new Exception("TEAM NO EXISTING");
            }
        }
    }

    public void ForceUnlockInteractible(int ID)
    {

    }
    public void ForceLockInteractible(int ID)
    {

    }
    public void TpLocalPlayerTo(GameObject obj)
    {

    }

    public void TpLocalPlayerNextTo(GameObject obj)
    {

    }
}
