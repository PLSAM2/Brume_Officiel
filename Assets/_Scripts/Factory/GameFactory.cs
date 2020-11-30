using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class GameFactory
{
    public static BrumeScript GetBrumeById(int id)
    {
        foreach(BrumeScript brume in GameManager.Instance.allBrume)
        {
            if(brume.GetInstanceID() == id)
            {
                return brume;
            }
        }
        return null;
    }

    public static Color GetColorTeam(Team myTeam)
    {
        switch (myTeam)
        {
            case Team.red:
                return new Color(1, 0.18f, 0.18f, 1f);

            case Team.blue:
                return new Color(0, 0.55f, 1f, 1f);

            default:
                return new Color(1, 1, 1f, 1f);
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
        try
        {
            if (GameManager.Instance.currentLocalPlayer != null)
            {
                /*
                if(RoomManager.Instance.GetPlayerData(GameManager.Instance.currentLocalPlayer.myPlayerId).playerCharacter == Character.Shili
                    && GameManager.Instance.currentLocalPlayer.myPlayerModule.isInGhost)
                {
                    return GameManager.Instance.currentLocalPlayer;
                }
                else
                {
                    return GameManager.Instance.currentLocalPlayer;
                }*/
                return GameManager.Instance.currentLocalPlayer;
            }
            else
            {
                return GameManager.Instance.networkPlayers[UiManager.Instance.specMode.playerSpected];
            }
        }
        catch
        {
            return null;
        }
    }

    public static List<LocalPlayer> GetPlayerInRange(float _range, Vector3 _pos)
    {
        List<LocalPlayer> pInRange = new List<LocalPlayer>();
        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (player.Value == GameManager.Instance.GetLocalPlayerObj()) { continue; }

            if (Vector3.Distance(_pos, player.Value.transform.position) <= _range)
            {
                pInRange.Add(player.Value);
            }
        }

        return pInRange;
    }

    public static List<LocalPlayer> GetPlayersInRangeByTeam ( float _range, Vector3 _pos, Team _team )
    {
        List<LocalPlayer> pInRange = new List<LocalPlayer>();
        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (player.Value == GameManager.Instance.GetLocalPlayerObj()) { continue; }

            if (Vector3.Distance(_pos, player.Value.transform.position) <= _range && player.Value.myPlayerModule.teamIndex == _team)
            {
                pInRange.Add(player.Value);
            }
        }

        return pInRange;
    }
}
