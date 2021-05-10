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
    public Text ms;

    public Dictionary<ushort, DebugPlayerListObj> debugPlayerListObj = new Dictionary<ushort, DebugPlayerListObj>();

    private void Awake() 
    {
        Init();
        StartCoroutine(DisplayFps());
    }

    private void Update()
    {
        ms.text = (NetworkManager.Instance.GetLocalClient().Client.RoundTripTime.LatestRtt * 1000).ToString("#####") + " Ms";
    }

    IEnumerator DisplayFps()
    {
        while (true)
        {
            fps.text = "FPS " + (int)(1f / Time.unscaledDeltaTime);
            yield return new WaitForSeconds(0.3f);
        }
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
    public void Close()
    {
        this.gameObject.SetActive(false);
    }

    public void ForceUnlockAltar(int ID)
    {
        altars[ID].Unlock();
    }
    public void ForceLockAltar(int ID)
    {
        altars[ID].state = State.Locked;
    }
    public void TpLocalPlayerTo(GameObject obj)
    {
        GameFactory.GetLocalPlayerObj().transform.position = obj.transform.position;
    }

    public void TpLocalPlayerNextTo(GameObject obj)
    {
        GameFactory.GetLocalPlayerObj().transform.position = obj.transform.position + Vector3.one * 2;
    }

    public void InfiniteStacks()
    {
    }

    public void NoCooldown()
    {

    }
    public void EndGame(bool win)
    {
        if (win)
        {

        } else
        {

        }
    }

    public void NextRound(bool win)
    {
        ushort? wxID = null;

        if (win)
        {
             wxID = GameFactory.GetPlayerCharacterInTeam(GameFactory.GetOtherTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam), GameData.Character.WuXin);
        }
        else
        {
             wxID = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, GameData.Character.WuXin);
        }

        if (wxID != null)
        {
            DamagesInfos _temp = new DamagesInfos();
            _temp.damageHealth = 1000;

            GameManager.Instance.networkPlayers[(ushort)wxID].DealDamages(_temp, transform,null, true, true);
        }
    }

}
