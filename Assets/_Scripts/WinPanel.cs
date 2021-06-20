using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class WinPanel : MonoBehaviour
{
    public TextMeshProUGUI wxBlue, reBlue, lengBlue, wxRed, reRed, lengRed;

    void Start()
    {
        foreach (KeyValuePair<ushort, PlayerData> p in RoomManager.Instance.actualRoom.playerList)
        {
            GetChampText(p.Value).text = p.Value.Name;
        }
    }

    TextMeshProUGUI GetChampText(PlayerData _player)
    {
        switch (_player.playerCharacter)
        {
            case Character.Re:
                return (GameFactory.GetRelativeTeam(_player.playerTeam) == Team.blue) ? reBlue : reRed;

            case Character.Leng:
                return (GameFactory.GetRelativeTeam(_player.playerTeam) == Team.blue) ? lengBlue : lengRed;

            default:
                return (GameFactory.GetRelativeTeam(_player.playerTeam) == Team.blue) ? wxBlue : wxRed;
        }

    }
}
