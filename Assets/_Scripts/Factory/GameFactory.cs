﻿using System.Collections;
using System.Collections.Generic;
using System.Linq;
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
            if (player.Value == GetLocalPlayerObj()) { continue; }

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
            if (player.Value == GetLocalPlayerObj()) { continue; }

            if (Vector3.Distance(_pos, player.Value.transform.position) <= _range && player.Value.myPlayerModule.teamIndex == _team)
            {
                pInRange.Add(player.Value);
            }
        }

        return pInRange;
    }

    public static bool IsInRangeOfHidden (float _range, Vector3 _pos, Team _team)
	{
        List<LocalPlayer> _allPlayers = GetPlayersInRangeByTeam(100000, _pos, _team);

        foreach(LocalPlayer _tempPlayer in _allPlayers)
		{
            if ((_tempPlayer.myPlayerModule.state & En_CharacterState.Hidden) == 0)
                continue;
            else if (Vector3.Distance(_pos, _tempPlayer.transform.position) <= _range)
			{
                return true;
			}
		}
        return false;

    }

    public static LocalPlayer GetLocalPlayerObj()
    {
        return GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID];
    }

    public static LocalPlayer GetFirstPlayerOfOtherTeam()
    {
        ushort? _id = RoomManager.Instance.actualRoom.playerList.Where
            (x => x.Value.playerTeam == GameFactory.GetOtherTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam))
            .FirstOrDefault().Key;

        if (_id != null)
        {
            return GameManager.Instance.networkPlayers[(ushort)_id];
        }
        else
        {
            return null;
        }

    }

    public static bool CheckIfPlayerIsInView(ushort id)
    {
        if(GetActualPlayerFollow().myPlayerId == id)
        {
            return true;
        }

        if (!GameManager.Instance.visiblePlayer.ContainsKey(GameManager.Instance.networkPlayers[id].transform))
        {
            return false;
        }

        if (GetActualPlayerFollow().myPlayerModule.isInBrume)
        {
            if (GameManager.Instance.networkPlayers[id].myPlayerModule.isInBrume)
            {
                if (!PlayersAreOnSameBrume(GameManager.Instance.networkPlayers[id].myPlayerModule, GetActualPlayerFollow().myPlayerModule))
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        else
        {
            if (GameManager.Instance.networkPlayers[id].myPlayerModule.isInBrume)
            {
                return false;
            }
        }


        return true;
    }
}
