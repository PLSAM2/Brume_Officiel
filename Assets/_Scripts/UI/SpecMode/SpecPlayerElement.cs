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

    public ushort playerId;

    public GameObject eye;

    SpecMode mySpecMode;

    public void Init(ushort _id, SpecMode _mySpecMode)
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

        mySpecMode = _mySpecMode;
    }

    public void SpecPlayer()
    {
        //CameraManager.Instance.SetParent(GameManager.Instance.networkPlayers[playerId].transform);
        mySpecMode.ChangeSpecPlayer(playerId);
    }
}
