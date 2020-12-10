using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class PlayerTeamElement : MonoBehaviour
{
    [SerializeField] GameObject panelPlayer;

    [SerializeField] Image myIcon;
    [SerializeField] Text myUsername;

    [SerializeField] GameObject iconSwap;
    [SerializeField] GameObject iconLoading;
    [SerializeField] GameObject iconPeak;
    [SerializeField] GameObject iconConfirme;
    [SerializeField] GameObject borders;

    public Character character;
    public void Init(PlayerData myPlayerdata, bool characterPick = false)
    {
        myUsername.text = myPlayerdata.Name;

        if (!characterPick)
        {
            myIcon.color = GameFactory.GetColorTeam(myPlayerdata.playerTeam);
        } else
        {
            if (NetworkManager.Instance.GetLocalPlayer().ID == myPlayerdata.ID)
            {
                borders.SetActive(true);
            } else
            {
                borders.SetActive(false);
            }
        }

        panelPlayer.SetActive(true);
    }

    public void SelectCharacter()
    {
        ChampSelectManager.Instance.PickCharacter(character);
    }

    public void SetStatut(ChampSelectStatut myStatut)
    {
        iconLoading.SetActive(myStatut == ChampSelectStatut.loading);
        iconPeak.SetActive(myStatut == ChampSelectStatut.pick);
        iconConfirme.SetActive(myStatut == ChampSelectStatut.confirme);
    }

    public void OnPlayerLeave()
    {
        panelPlayer.SetActive(false);
    }

    public void SetSwapIcon(bool value)
    {
        iconSwap.SetActive(value);
    }

    public enum ChampSelectStatut
    {
        loading,
        pick,
        confirme
    }
}
