using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class EndZoneUIGroup : MonoBehaviour
{
	public TextMeshProUGUI timer;
	public TextMeshProUGUI EndZoneText;
	public Image endZoneBarTimer;
	public Animator endZoneAnim;
	public GameObject endZoneTimerObj;

	public void Init(Team team)
	{
		EndZoneText.color = GameFactory.GetRelativeColor(team);

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == team)
        {
			EndZoneText.text = "Attack The Center";
		} else
        {
			EndZoneText.text = "Defend The Center";
		}

		endZoneTimerObj.SetActive(true);
	}


}
