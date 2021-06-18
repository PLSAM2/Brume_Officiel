using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class EndPanel : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI endPanelText;
    [SerializeField] GameObject endPanel;
    [SerializeField] Animator endPanelAnimator;
	[SerializeField] TextMeshProUGUI endGameText;
	[SerializeField] AudioClip VictoryAudio, DefeatAudio;
	public EndGameScore endGameScore;

	private Team team;
	private bool victory;


	private void Start()
    {
		endGameScore.Init();

	}
    public void Appear(bool victory, Team team, bool wuxinKilled = false, bool lastRound = false)
	{
		this.team = team;
		this.victory = victory;
		endPanel.SetActive(true);

        if (lastRound)
		{
			if (victory)
			{
				endPanelText.text = "GAME WIN";
			}
			else
			{
				endPanelText.text = "GAME LOST";
			}

			endPanelAnimator.SetTrigger("LastRound");
		} else
		{
			if (victory)
			{
				endPanelText.text = "VICTORY";
			}
			else
			{
				endPanelText.text = "DEFEAT";
			}

			endPanelAnimator.SetTrigger("Appear");
		}



		if (wuxinKilled)
		{
			endGameText.text = "WU XIN KILLED";
		}
		else
		{
			endGameText.text = "END ZONE CAPTURED";
		}


		endGameText.gameObject.SetActive(true);

	}

	public void TextAppear()
    {
		if (victory)
		{
			AudioManager.Instance.Play2DAudio(VictoryAudio);
		}
		else
		{
			AudioManager.Instance.Play2DAudio(DefeatAudio);
		}
	}
	public void EndGameScore()
    {
		endGameScore.EndGame(team);
	}
}
