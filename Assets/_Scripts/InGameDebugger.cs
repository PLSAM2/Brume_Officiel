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

    public Dictionary<ushort, DebugPlayerListObj> debugPlayerListObj = new Dictionary<ushort, DebugPlayerListObj>();

    private void Awake() 
    {
        Init();
    }

    private void Update()
    {
        fps.text = "FPS " +  (int)(1f / Time.unscaledDeltaTime);
    }

    private void Init()
    {
        foreach (PlayerData p in RoomManager.Instance.actualRoom.playerList.Values)
        {
            GameObject _temp = null;
            switch (p.playerTeam)
            {
                case GameData.Team.none:
                    return;
                case GameData.Team.red:
                    _temp = RedPlayerLayout;
                    break;
                case GameData.Team.blue:
                    _temp = bluePlayerLayout;
                    break;
                default:
                    throw new Exception("TEAM NO EXISTING");
            }

            if (_temp != null)
            {
                GameObject _tListObj = Instantiate(playerListObj, _temp.transform);
                _tListObj.GetComponent<DebugPlayerListObj>().Init(p, this);
                debugPlayerListObj.Add(p.ID, _tListObj.GetComponent<DebugPlayerListObj>());
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

    public void InfiniteStacks()
    {

    }

    public void NoCooldown()
    {

    }
}
