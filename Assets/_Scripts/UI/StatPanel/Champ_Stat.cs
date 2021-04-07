using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class Champ_Stat : MonoBehaviour
{
    public TextMeshProUGUI username;

    public TextMeshProUGUI kill;
    public TextMeshProUGUI damage;

    public GameObject deathPanel;
    public GameObject iconDeath;
    public GameObject skip;

    public bool isSet = false;

    public void Init(string _myUsername, Team _team, int _numberOfKill, int _numberOfDamage)
    {
        isSet = true;
        username.text = _myUsername.ToString();
        username.color = GameFactory.GetRelativeColor(_team);

        kill.text = _numberOfKill.ToString();
        damage.text = _numberOfDamage.ToString();
    }

    public void SetSkip(bool state = true)
    {
        skip.SetActive(state);
    }

    public void Kill()
    {
        iconDeath.SetActive(true);
        deathPanel.SetActive(true);
    }

    public void SetPlayerOut()
    {
        iconDeath.SetActive(false);
        deathPanel.SetActive(true);

        username.text = "";
        kill.text = "";
        damage.text = "";
    }
}
