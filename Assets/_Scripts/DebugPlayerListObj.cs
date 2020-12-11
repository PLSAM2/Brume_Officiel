using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DebugPlayerListObj : MonoBehaviour
{
    public Text mainText;
    public InGameDebugger debugger;
    PlayerData p;

    public void Init(PlayerData p, InGameDebugger d)
    {
        this.p = p;
        debugger = d;
        mainText.text = p.ID + " / " + p.Name + " / " + p.playerCharacter;
    }

    public void TpTo()
    {

    }

    public void Kill()
    {

    }

    public void Heals()
    {

    }
}
