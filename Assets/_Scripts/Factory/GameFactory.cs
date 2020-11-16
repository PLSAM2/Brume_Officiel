﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class GameFactory
{
    public static int GerateRandomNumer(int min, int max)
    {
        return Random.Range(min, max);
    }

    public static void ChangeIconMinimap(Image myImage, Sprite mySprite, Color myColor)
    {
        myImage.color = myColor;

        if (mySprite != null)
        {
            myImage.sprite = mySprite;
        }
    }

    public static ushort GetMaxLifeOfPlayer(ushort id)
    {
        return GameManager.Instance.networkPlayers[id].myPlayerModule.characterParameters.maxHealth;
    }

    public static Team GetOtherTeam(Team team)
    {
        if (team == Team.blue)
        {
            return Team.red;
        }
        else
        {
            return Team.blue;
        }
    }
}
