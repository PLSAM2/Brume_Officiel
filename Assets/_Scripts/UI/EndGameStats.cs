using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using DG.Tweening;

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

    public TextMeshProUGUI endTime;

    public TextMeshProUGUI countText;

    //color altar
    [SerializeField] Color altarAWAKEN, altarUNSEALED;


    public void Init()
    {
		countText.text = 0 + "/" + Math.Ceiling((float)(RoomManager.Instance.actualRoom.playerList.Count) / 2);

        //set stat
        SetChampStat();

        StatManager.Instance.endGameTime = GameManager.Instance.timer;

        endTime.text = (int)Math.Floor(StatManager.Instance.endGameTime / 60) + ":" + ((int) StatManager.Instance.endGameTime % 60).ToString("D2");

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
                    _killEvent.username.text = RoomManager.Instance.GetPlayerData(((killEvent) _event.Key).idPlayer).Name;
                    _killEvent.username.color = GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(((killEvent)_event.Key).idPlayer).playerTeam);

                    _killEvent.icon.color = GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(((killEvent)_event.Key).idPlayer).playerTeam);

                    _killEvent.perso.text = "(" + RoomManager.Instance.GetPlayerData(((killEvent)_event.Key).idPlayer).playerCharacter + ")";

                    _killEvent.killer.text = "By " + RoomManager.Instance.GetPlayerData(((killEvent)_event.Key).idKiller).Name;
                    _killEvent.killer.color = GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(((killEvent)_event.Key).idKiller).playerTeam);
                    break;

                case statEvent.type.altar:
                    objEvent = Instantiate(altarEventPrefab, transform);

                    AltarEvent_Stat _altarEvent = objEvent.GetComponent<AltarEvent_Stat>();
                    _altarEvent.text.text = "Altar " + ((altarEvent)_event.Key).altarPos + " " + ((altarEvent)_event.Key).myState.ToString();

                    Color colorAltar = altarAWAKEN;
                    switch (((altarEvent)_event.Key).myState)
                    {
                        case altarEvent.state.UNSEALED:
                            colorAltar = altarUNSEALED;
                            break;

                        case altarEvent.state.CLEANSED:
                            colorAltar = GameFactory.GetRelativeColor(((altarEvent)_event.Key).myTeam);
                            break;
                    }
                    _altarEvent.text.color = colorAltar;
                    _altarEvent.icon.color = colorAltar;
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
		countText.text = count + "/" + Math.Ceiling((float)(RoomManager.Instance.actualRoom.playerList.Count) / 2);

        if (!RoomManager.Instance.PlayerExist(_playerID))
        {
            return;
        }

        switch (GameFactory.GetRelativeTeam(RoomManager.Instance.GetPlayerData(_playerID).playerTeam))
        {
            case Team.none:
                return;
            case Team.blue:
                switch (RoomManager.Instance.GetPlayerData(_playerID).playerCharacter)
                {
                    case Character.none:
                        return;
                    case Character.WuXin:
                        wxBlue.SetSkip();
                        break;
                    case Character.Re:
                        reBlue.SetSkip();
                        break;
                    case Character.Leng:
                        lengBlue.SetSkip();
                        break;
                    case Character.test:
                        return;
                    default: throw new Exception("Not existing");
                }

                break;
            case Team.red:
                switch (RoomManager.Instance.GetPlayerData(_playerID).playerCharacter)
                {
                    case Character.none:
                        return;
                    case Character.WuXin:
                        wxRed.SetSkip();
                        break;
                    case Character.Re:
                        reRed.SetSkip();
                        break;
                    case Character.Leng:
                        lengRed.SetSkip();
                        break;
                    case Character.test:
                        return;
                    default: throw new Exception("Not existing");
                }


                break;
            case Team.spectator:
                return;
            default: throw new Exception("Not existing");
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
