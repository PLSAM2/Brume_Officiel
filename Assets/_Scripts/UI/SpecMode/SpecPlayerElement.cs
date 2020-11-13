using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class SpecPlayerElement : MonoBehaviour
{
    [SerializeField] Image backImgColor;
    [SerializeField] TMP_Text usernameText;

    [SerializeField] Color blueColor;
    [SerializeField] Color redColor;

    ushort playerId;

    [SerializeField] GameObject eye;

    public void Init(ushort _id)
    {
        playerId = _id;

        switch (RoomManager.Instance.GetPlayerData(playerId).playerTeam)
        {
            case GameData.Team.red:
                backImgColor.color = redColor;
                break;
            case GameData.Team.blue:
                backImgColor.color = blueColor;
                break;
        }

        usernameText.text = RoomManager.Instance.GetPlayerData(playerId).Name;
    }

    public void SpecPlayer()
    {


        eye.SetActive(true);
    }
}
