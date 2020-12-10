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

    public void Init(Color allyTextColor, Color enemyTextColor, string allyScoreText, string enemyScoreText)
    {
        allyText.color = allyTextColor;
        newAllyText.color = allyTextColor;
        enemyText.color = enemyTextColor;
        newenemyText.color = enemyTextColor;
        allyText.text = allyScoreText;
        enemyText.text = enemyScoreText;
    }

    public void EndGame(ushort newPoints, Team team)
    {
        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == team)
        {
            newAllyText.text = RoomManager.Instance.actualRoom.scores[team] + newPoints + "";
            animator.SetTrigger("UpdateAllyScore");
        } else
        {
            newenemyText.text = RoomManager.Instance.actualRoom.scores[team] + newPoints + "";
            animator.SetTrigger("UpdateEnemyScore");
        }

    }
}
