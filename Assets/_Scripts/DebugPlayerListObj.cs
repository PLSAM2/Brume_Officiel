using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DebugPlayerListObj : MonoBehaviour
{
    public Text mainText;
    public InGameDebugger debugger;
    PlayerData p;
    LocalPlayer pObj;

    public void Init(PlayerData p, InGameDebugger d)
    {
        this.p = p;
        pObj = GameManager.Instance.networkPlayers[p.ID];
        debugger = d;
        mainText.text = p.ID + " / " + p.Name + " / " + p.playerCharacter;
    }

    public void TpTo()
    {
        GameFactory.GetLocalPlayerObj().transform.position = pObj.gameObject.transform.position + Vector3.one / 10;
    }

    public void Kill()
    {
        DamagesInfos _temp = new DamagesInfos();
        _temp.damageHealth = 1000;
        pObj.DealDamages(_temp, transform, null, true, true);
    }

    public void Heals()
    {
        pObj.HealPlayer(1000);
    }
}
