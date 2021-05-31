using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class UIAltarList : MonoBehaviour
{
    public Animator altarBlueAnim;
    public Animator altarRedAnim;
    public Animator altarCenterAnim;

    public Image altarBlueImg;
    public Image altarRedImg;
    public Image altarCenterImg;

    int blueGain = 0;
    int redGain = 0;

    public void GainTeam(Team _team)
    {
        switch (_team == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            case true:
                GainBlue();
                break;

            case false:
                GainRed();
                break;
        }
    }

    void GainBlue()
    {
        blueGain++;

        switch (blueGain)
        {
            case 1:
                altarBlueImg.color = GameFactory.GetColorTeam(Team.blue);
                //altarBlueAnim.SetTrigger("Gain");

                //Play sound
                break;

            case 2:
                altarCenterImg.color = GameFactory.GetColorTeam(Team.blue);
                //altarCenterAnim.SetTrigger("Gain");

                //Play sound
                break;
        }
    }

    void GainRed()
    {
        redGain++;

        switch (redGain)
        {
            case 1:
                altarRedImg.color = GameFactory.GetColorTeam(Team.red);
                //altarRedAnim.SetTrigger("Gain");

                //Play sound
                break;

            case 2:
                altarCenterImg.color = GameFactory.GetColorTeam(Team.red);
               // altarCenterAnim.SetTrigger("Gain");

                //Play sound
                break;
        }
    }
}
