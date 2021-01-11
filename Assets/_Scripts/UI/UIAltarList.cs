using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class UIAltarList : MonoBehaviour
{
    public List<Image> altarImagesAlly = new List<Image>();
    public List<Image> altarImagesEnemy = new List<Image>();

    public GameObject separator;
    public void ResetImageState()
    {
        separator.SetActive(false);

        foreach (Image altImg in altarImagesAlly)
        {
            altImg.gameObject.SetActive(false);
        }
        foreach (Image altImg in altarImagesEnemy)
        {
            altImg.gameObject.SetActive(false);
        }
    }

    public void DisplayImage(int index, Team team = Team.red)
    {
        switch (team)
        {
            case Team.none:
                throw new System.Exception("None team");
            case Team.red:
                altarImagesAlly[index].gameObject.SetActive(true);
                break;
            case Team.blue:
                altarImagesEnemy[index].gameObject.SetActive(true);
                break;
            default:
                throw new System.Exception("Team not existing");
        }

        separator.SetActive(true);
    }
}
