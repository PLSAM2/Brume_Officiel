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
    public TextMeshProUGUI capture;

    public bool isSet = false;

    public CanvasGroup group;

    public void Init(string _myUsername, Team _team, int _numberOfKill, int _numberOfDamage, int _capture)
    {
        isSet = true;
        username.text = _myUsername.ToString();
        username.color = GameFactory.GetRelativeColor(_team);

        kill.text = _numberOfKill.ToString();
        damage.text = _numberOfDamage.ToString();
        capture.text = _capture.ToString();
    }

    public void SetPlayerOut()
    {
        group.alpha = 0;

        username.text = "";
        kill.text = "";
        damage.text = "";
        capture.text = "";
    }
}
