﻿using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class GameFactory
{
    public static Brume GetBrumeById(int id)
    {
        foreach(Brume brume in GameManager.Instance.allBrume)
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
                return new Color(0.855f, 0.286f, 0.302f, 1f);

            case Team.blue:
                return new Color(0.408f, 0.678f, 0.95f, 1f);

            default:
                return new Color(1, 1, 1f, 1f);
        }
    }

    public static Color GetReferentialPlayerTeamColor(Team playerTeam)
    {
        if (NetworkManager.Instance.GetLocalPlayer() != null)
        {
            if (NetworkManager.Instance.GetLocalPlayer().playerTeam == playerTeam)
            {
                return GetColorTeam(Team.blue);
            }
        }

        return GetColorTeam(Team.red);

    }


    public static ushort? GetPlayerCharacterInTeam(Team team, Character character)
    {
        PlayerData _tempPlayer = RoomManager.Instance.actualRoom.playerList.Values.Where(x => x.playerTeam == team && x.playerCharacter == character).FirstOrDefault();

        if (_tempPlayer != null)
        {
            return _tempPlayer.ID;
        }

        return null;
    }
    public static List<PlayerData> GetAllPlayerInTeam(Team team)
    {
        List<PlayerData> _tempPlayer = RoomManager.Instance.actualRoom.playerList.Values.Where(x => x.playerTeam == team).ToList();
        return _tempPlayer;
    }

    public static int GenerateRandomNumer(int min, int max)
    {
        return Random.Range(min, max);
    }

    public static ushort GetMaxLifeOfPlayer(ushort id)
    {
        if (GameManager.Instance.networkPlayers.ContainsKey(id))
        {
            return GameManager.Instance.networkPlayers[id].myPlayerModule.characterParameters.maxHealth;
        }

        return 0;
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
    public static bool IsOnMyTeam(ushort playerID)
    {
        if (NetworkManager.Instance.GetLocalPlayer() != null && RoomManager.Instance.actualRoom.playerList.ContainsKey(playerID))
        {
            if (RoomManager.Instance.GetPlayerData(playerID).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                return true;
            }
        }

        return false;

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
        if (GameManager.Instance.networkPlayers.ContainsKey(NetworkManager.Instance.GetLocalPlayer().ID))
        {
            return GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID];
        } else
        {
            return null;
        }

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
        if (!GetActualPlayerFollow()) { return false; }

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

    public static bool DoSound(Vector3 pos)
    {
        PlayerModule currentPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

        Brume currentBrume = null;
        RaycastHit hit;
        if (Physics.Raycast(pos + Vector3.up * 0.5f, -Vector3.up, out hit, 10, GameManager.Instance.brumeLayer))
        {
            currentBrume = hit.transform.GetComponent<BrumePlane>().myBrume;
        }

        if (currentPlayer.isInBrume)
        {
            if(currentBrume != null)
            {
                if(currentBrume.GetInstanceID() != currentPlayer.brumeId)
                {
                    return false;
                }
            }
            return true;
        }
        else
        {
            if (currentBrume == null)
            {
                return true;
            }
            return false;
        }
    }
}
