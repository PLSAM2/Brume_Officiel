using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class AllieWaypoint : Waypoint
{
    public GameObject wxImg, reImg, lengImg;

    public void Init(Character _perso)
    {
        switch (_perso)
        {
            case Character.WuXin:
                wxImg.SetActive(true);
                break;

            case Character.Re:
                reImg.SetActive(true);
                break;

            case Character.Leng:
                lengImg.SetActive(true);
                break;
        }
    }
}
