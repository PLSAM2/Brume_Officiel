using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class GameFactory
{
    public static Color GetColorTeam(Team myTeam)
    {
        switch (myTeam)
        {
            case Team.red:
                return new Color(255, 75, 36);

            case Team.blue:
                return new Color(36, 152, 255);

            default:
                return new Color(255, 255, 255);
        }
    }

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

    public static bool PlayersAreOnSameBrume(PlayerModule p1, PlayerModule p2)
    {
        if(p1.isInBrume && p2.isInBrume
            && p1.brumeId == p2.brumeId)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static bool PlayerWardAreOnSameBrume(PlayerModule p, Ward ward)
    {
        if (p.isInBrume && ward.isInBrume &&
            p.brumeId == ward.brumeId)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static LocalPlayer GetActualPlayerFollow()
    {
        if (GameManager.Instance.currentLocalPlayer != null)
        {
             return GameManager.Instance.currentLocalPlayer;
        }
        else
        {
            return GameManager.Instance.networkPlayers[UiManager.Instance.specMode.playerSpected];
        }
    }
}
