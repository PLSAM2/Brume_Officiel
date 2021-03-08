using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class EndZoneTimerUIGroup : MonoBehaviour
{
	public TextMeshProUGUI timer;
	public TextMeshProUGUI overtimeText;
	public Image endZoneBarTimer;
	public Animator endZoneAnim;
	public GameObject endZoneTimerObj;

	public void Init(Team team)
    {
		endZoneTimerObj.SetActive(true);

		timer.color = GameFactory.GetRelativeColor(team);
		overtimeText.color = GameFactory.GetRelativeColor(team);
		endZoneBarTimer.color = GameFactory.GetRelativeColor(team);

	}


}
