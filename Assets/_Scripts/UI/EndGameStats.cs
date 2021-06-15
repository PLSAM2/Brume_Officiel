using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using DG.Tweening;
using static altarEvent;

public class EndGameStats : MonoBehaviour
{
    //blue
    public Champ_Stat wxBlue;
    public Champ_Stat reBlue;
    public Champ_Stat lengBlue;

    //red
    public Champ_Stat wxRed;
    public Champ_Stat reRed;
    public Champ_Stat lengRed;

    //slider
    public Slider mySlider;
    public RectTransform posSlider;

    public GameObject altarEventPrefab;
    public GameObject killEventPrefab;

    public TextMeshProUGUI countText;

    //score
    public GameObject blueWinPanel;
    public GameObject redWinPanel;

    public TextMeshProUGUI blueScore;
    public TextMeshProUGUI redScore;

    public void Init()
    {
		countText.text = "SKIP (0/" + Math.Ceiling((float)(RoomManager.Instance.actualRoom.playerList.Count) / 2) + ")";

        //set stat
        SetChampStat();

        StatManager.Instance.endGameTime = GameManager.Instance.timer;

        blueWinPanel.SetActive(StatManager.Instance.isVictory);
        redWinPanel.SetActive(!StatManager.Instance.isVictory);

        blueScore.text = RoomManager.Instance.actualRoom.scores[GameFactory.GetRelativeTeam(Team.blue)].ToString();
        redScore.text = RoomManager.Instance.actualRoom.scores[GameFactory.GetRelativeTeam(Team.red)].ToString();

        StartCoroutine(DisplayTimeline());
    }

    IEnumerator DisplayTimeline()
    {
        yield return new WaitForSeconds(1);

        foreach(KeyValuePair<statEvent, float> _event in StatManager.Instance.timeLineEvent){

            float objectif = _event.Value / StatManager.Instance.endGameTime;

            mySlider.DOValue(objectif, 0.6f);

            yield return new WaitForSeconds(1);

            GameObject objEvent = null;
            switch (_event.Key.myTypeEvent)
            {
                case statEvent.type.kill:
                    objEvent = Instantiate(killEventPrefab, transform);

                    KillEvent_Stat _killEvent = objEvent.GetComponent<KillEvent_Stat>();
                    _killEvent.SetInMyTeam(
                        RoomManager.Instance.GetPlayerData(((killEvent)_event.Key).idKiller).playerTeam 
                        == NetworkManager.Instance.GetLocalPlayer().playerTeam);

                    break;

                case statEvent.type.altar:
                    objEvent = Instantiate(altarEventPrefab, transform);

                    AltarEvent_Stat _altarEvent = objEvent.GetComponent<AltarEvent_Stat>();
                    _altarEvent.SetInMyTeam(((altarEvent)_event.Key).myTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam);
                    break;
            }

            objEvent.transform.position = posSlider.position;

            //todo play sound
            //todo shaking

        }

        mySlider.DOValue(1, 0.6f);
        //todo play sound
        //todo shaking

    }

    public void NewPlayerWantToSkip(ushort count, ushort _playerID)
    {
		countText.text = "SKIP (" + count + "/" + Math.Ceiling((float)(RoomManager.Instance.actualRoom.playerList.Count) / 2) + ")";
        
        if(_playerID == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            countText.color = Color.green;
        }
    }


    public void SkipToNextRound()
    {
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			using (Message _message = Message.Create(Tags.AskSkipToNextRound, _writer))
			{
				NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
			}
		}
	}

    void SetChampStat()
    {
        foreach(KeyValuePair<ushort, PlayerData> p in RoomManager.Instance.actualRoom.playerList)
        {
            int numberOfKiLL = 0;
            int numberOfDamage = 0;
            int numberOfCapture = StatManager.Instance.GetNumberOfCapture(p.Value.playerTeam);

            if (StatManager.Instance.killPlayer.ContainsKey(p.Key))
            {
                numberOfKiLL = StatManager.Instance.killPlayer[p.Key];
            }

            if (StatManager.Instance.damagePlayer.ContainsKey(p.Key))
            {
                numberOfDamage = StatManager.Instance.damagePlayer[p.Key];
            }

            GetChampStat(p.Value).Init(p.Value.Name, p.Value.playerTeam, numberOfKiLL, numberOfDamage, numberOfCapture);
        }

        if (!wxBlue.isSet)
        {
            wxBlue.SetPlayerOut();
        }
        if (!reBlue.isSet)
        {
            reBlue.SetPlayerOut();
        }
        if (!lengBlue.isSet)
        {
            lengBlue.SetPlayerOut();
        }

        if (!wxRed.isSet)
        {
            wxRed.SetPlayerOut();
        }
        if (!reRed.isSet)
        {
            reRed.SetPlayerOut();
        }
        if (!lengRed.isSet)
        {
            lengRed.SetPlayerOut();
        }
    } 

    Champ_Stat GetChampStat(PlayerData _player)
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
