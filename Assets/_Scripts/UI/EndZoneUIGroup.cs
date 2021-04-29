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
            switch (NetworkManager.Instance.GetLocalPlayer().playerCharacter)
            {
                case Character.none:
                    return;
                case Character.WuXin:
                    EndZoneText.text = "Attack The Center";
                    break;
                case Character.Re:
                    EndZoneText.text = "Defend WuXin";
                    break;
                case Character.Leng:
                    EndZoneText.text = "Defend WuXin";
                    break;
                case Character.test:
                    return;
                default: throw new System.Exception();
            }

		} else
        {
			EndZoneText.text = "Defend The Center";
		}

		endZoneTimerObj.SetActive(true);
	}


}
