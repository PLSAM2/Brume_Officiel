using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class EndGameScore : MonoBehaviour
{
    public Animator animator;
    public TextMeshProUGUI allyText;
    public TextMeshProUGUI newAllyText;
    public TextMeshProUGUI enemyText;
    public TextMeshProUGUI newenemyText;

    public void Init(string allyScoreText, string enemyScoreText)
    {
        allyText.text = allyScoreText;
        enemyText.text = enemyScoreText;
    }

    public void EndGame(Team team)
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == team)
        {
            newAllyText.text = RoomManager.Instance.actualRoom.scores[team]+ "";
            animator.SetTrigger("UpdateAllyScore");
        } else
        {
            newenemyText.text = RoomManager.Instance.actualRoom.scores[team] + "";
            animator.SetTrigger("UpdateEnemyScore");
        }

    }
}
