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
    public Image endZoneBar;
    public Image endZoneBarBackground;
    public Animator endZoneAnim;
    public GameObject endZoneTimerObj;

    public void Init(Team team)
    {

        Color _temp = GameFactory.GetRelativeColor(team);

        timer.color = _temp;
        EndZoneText.color = _temp;
        endZoneBar.color = _temp;
        endZoneBarBackground.color = new Color(_temp.r, _temp.g, _temp.b, 0.2f);

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

        }
        else
        {
            EndZoneText.text = "Defend The Center";
        }

        endZoneTimerObj.SetActive(true);
    }


    public void TimerElapsed()
    {

        Color _temp = GameFactory.GetColorTeam(Team.blue);

        timer.gameObject.SetActive(false);

        timer.color = _temp;
        EndZoneText.color = _temp;
        endZoneBar.color = _temp;
        endZoneBarBackground.color = new Color(_temp.r, _temp.g, _temp.b, 0.2f);

        EndZoneText.text = "Attack The Center";

    }

}
