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
		EndZoneText.text = "Defend The Center";
		endZoneTimerObj.SetActive(true);

		//timer.color = GameFactory.GetRelativeColor(team);

		//endZoneBarTimer.color = GameFactory.GetRelativeColor(team);



	}


}
