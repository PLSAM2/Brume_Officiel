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

    public void Init()
    {
        Team team = NetworkManager.Instance.GetLocalPlayer().playerTeam;

        string redTeamScore = RoomManager.Instance.actualRoom.scores[Team.red].ToString();
        string blueTeamScore = RoomManager.Instance.actualRoom.scores[Team.blue].ToString();

        if (team == Team.blue)
        {
            allyText.text = blueTeamScore;
            enemyText.text = redTeamScore;
        }
        else if (team == Team.red)
        {
            allyText.text = redTeamScore;
            enemyText.text = blueTeamScore;
        }


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
