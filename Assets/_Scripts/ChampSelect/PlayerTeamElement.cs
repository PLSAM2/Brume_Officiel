using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerTeamElement : MonoBehaviour
{
    [SerializeField] GameObject panelPlayer;

    [SerializeField] Image myIcon;
    [SerializeField] Text myUsername;

    [SerializeField] GameObject iconLoading;
    [SerializeField] GameObject iconPeak;
    [SerializeField] GameObject iconConfirme;

    public void Init(PlayerData myPlayerdata)
    {
        myUsername.text = myPlayerdata.Name;
        myIcon.color = GameFactory.GetColorTeam(myPlayerdata.playerTeam);

        panelPlayer.SetActive(true);
    }

    public void SetStatut(ChampSelectStatut myStatut)
    {
        iconLoading.SetActive(myStatut == ChampSelectStatut.loading);
        iconPeak.SetActive(myStatut == ChampSelectStatut.peak);
        iconConfirme.SetActive(myStatut == ChampSelectStatut.confirme);
    }

    public void OnPlayerLeave()
    {
        panelPlayer.SetActive(false);
    }

    public enum ChampSelectStatut
    {
        loading,
        peak,
        confirme
    }
}
