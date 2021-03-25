using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class Champ_Stat : MonoBehaviour
{
    public TextMeshProUGUI username;

    public TextMeshProUGUI kill;
    public TextMeshProUGUI damage;

    public GameObject DeathPanel;

    public void Init(string _myUsername, Team _team, int _numberOfKill, int _numberOfDamage)
    {
        username.text = _myUsername.ToString();
        username.color = GameFactory.GetRelativeColor(_team);

        kill.text = _numberOfKill.ToString();
        damage.text = _numberOfDamage.ToString();
    }

    public void Kill()
    {
        DeathPanel.SetActive(true);
    }
}
