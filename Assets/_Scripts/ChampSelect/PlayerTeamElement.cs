using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class PlayerTeamElement : MonoBehaviour
{
    [SerializeField] List<GameObject> myChar;
    [SerializeField] TextMeshProUGUI myUsername;

    [SerializeField] Image charBorderImg;
    [SerializeField] Image nameBorderImg;

    [SerializeField] GameObject iconSwap;
    [SerializeField] GameObject iconPick;
    [SerializeField] GameObject iconReady;
    public void Init(PlayerData myPlayerdata)
    {
        myUsername.text = myPlayerdata.Name;


        if (NetworkManager.Instance.GetLocalPlayer().ID == myPlayerdata.ID)
        {
            charBorderImg.color = Color.white;
            nameBorderImg.color = Color.white;
        }
    }


    public void SetStatut(ChampSelectStatut myStatut)
    {
        //iconPick.SetActive(myStatut == ChampSelectStatut.pick);
        //iconReady.SetActive(myStatut == ChampSelectStatut.ready);
    }

    public void OnPlayerLeave()
    {
        myUsername.text = "";
        PickCharacter(Character.none);
    }


    public void PickCharacter(Character chara)
    {

        foreach (GameObject item in myChar)
        {
            item.SetActive(false);
        }

        switch (chara)
        {
            case Character.none:
                break;
            case Character.WuXin:
                myChar[0].SetActive(true);
                break;
            case Character.Re:
                myChar[1].SetActive(true);
                break;
            case Character.Leng:
                myChar[2].SetActive(true);
                break;
            default:
                Debug.LogError("Char not existing");
                break;
        }
    }
    public void SetSwapIcon(bool value)
    {
        iconSwap.SetActive(value);
    }

    public enum ChampSelectStatut
    {
        pick,
        ready
    }
}
