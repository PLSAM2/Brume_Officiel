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

    private void Start()
    {
		endGameScore.Init();

	}
    public void Appear(bool victory, Team team, bool wuxinKilled = false)
	{
		this.team = team;
		endPanel.SetActive(true);

		endPanelAnimator.SetTrigger("Appear");

        if (victory)
		{
			AudioManager.Instance.Play2DAudio(VictoryAudio);
			endPanelText.text = "VICTORY";
        } else
		{
			AudioManager.Instance.Play2DAudio(DefeatAudio);
			endPanelText.text = "DEFEAT";
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


	public void EndGameScore()
    {
		endGameScore.EndGame(team);
	}
}
