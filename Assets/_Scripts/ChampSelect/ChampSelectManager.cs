using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class ChampSelectManager : MonoBehaviour
{
    private static ChampSelectManager _instance;
    public static ChampSelectManager Instance { get { return _instance; } }

    public List<CharacterListObj> redTeamCharacterList = new List<CharacterListObj>();
    public List<CharacterListObj> blueTeamCharacterList = new List<CharacterListObj>();
    public GameObject startButton;
    public TextMeshProUGUI roundText;

    public Dictionary<ushort, CharacterListObj> linkPlayerCharacterListObj = new Dictionary<ushort, CharacterListObj>();

    [Header("Swap")]
    public GameObject characterSwapPanelReceiver;
    public GameObject characterSwapPanelSender;
    public TextMeshProUGUI characterSwapPanelReceiverText;
    public TextMeshProUGUI characterSwapPanelSenderText;
    private ushort askingSwapPlayerId = 0;

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }

        if (RoomManager.Instance == null)
        {
            Debug.LogError("NO ROOM MANAGER");
            return;
        }

        InitChampSelect();

        RoomManager.Instance.client.MessageReceived += MessageReceived;
    }

    private void InitChampSelect()
    {
        List<CharacterListObj> _tempList;

        switch (NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            case Team.red:
                _tempList = blueTeamCharacterList;
                break;
            case Team.blue:
                _tempList = redTeamCharacterList;
                break;
            default: throw new System.Exception("Team non existante");

        }

        foreach (CharacterListObj item in _tempList)
        {
            item.GetComponent<Button>().interactable = false;
        }

        roundText.text = "Round : " + RoomManager.Instance.roundCount;
    }

    private void OnDisable()
    {
        RoomManager.Instance.client.MessageReceived -= MessageReceived;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {

        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SetCharacter)
            {
                PickCharacterInServer(sender, e);
            }
            if (message.Tag == Tags.AskForCharacterSwap)
            {
                AskForCharacterSwapInServer(sender, e);
            }
            if (message.Tag == Tags.CharacterSwap)
            {
                CharacterSwapInServer(sender, e);
            }
            if (message.Tag == Tags.RefuseCharacterSwap)
            {
                RefuseCharacterSwapInServer(sender, e);
            }
        }
    }


    public void PickCharacter(GameData.Character character)
    {
        if (character == NetworkManager.Instance.GetLocalPlayer().playerCharacter)
        {
            return;
        }

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)character);

            using (Message message = Message.Create(Tags.SetCharacter, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }
    }


    private void PickCharacterInServer(object sender, MessageReceivedEventArgs e)
    {
        ushort _playerID;
        Character _character;

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                _playerID = reader.ReadUInt16();
                _character = (Character)reader.ReadUInt16();
            }
        }

        SetCharacter(_playerID, _character);

        if (_playerID == askingSwapPlayerId)
        {
            StopSwap();
        }


        if (NetworkManager.Instance.GetLocalPlayer().IsHost)
        {
            if (CheckIfCanLaunch())
            {
                startButton.SetActive(true);
            }
            else
            {
                startButton.SetActive(false);
            }

        }
    }

    private void AskForCharacterSwapInServer(object sender, MessageReceivedEventArgs e) // Recu uniquement par l'envoyeur et la personne ciblé
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _playerID = reader.ReadUInt16(); // joueur demandant le swap
                ushort _targetedID = reader.ReadUInt16(); // joueur target par le swap
                Character _character = (Character)reader.ReadUInt16();

                askingSwapPlayerId = _playerID;

                if (_playerID != NetworkManager.Instance.GetLocalPlayer().ID)
                {
                    characterSwapPanelReceiver.SetActive(true);
                    characterSwapPanelSender.SetActive(false);
                    characterSwapPanelReceiverText.text = RoomManager.Instance.GetPlayerData(_playerID).Name + " want to swap " + _character.ToString() + " with you";
                }
                else
                {
                    characterSwapPanelSender.SetActive(true);
                    characterSwapPanelReceiver.SetActive(false);
                    characterSwapPanelSenderText.text = "Asking " + RoomManager.Instance.GetPlayerData(_targetedID).Name + " to swap";
                }

            }
        }
    }
    public void AcceptSwap()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(askingSwapPlayerId);

            using (Message message = Message.Create(Tags.CharacterSwap, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }
    }
    public void RefuseSwap()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(askingSwapPlayerId);

            using (Message message = Message.Create(Tags.RefuseCharacterSwap, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void CharacterSwapInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort askingPlayer = reader.ReadUInt16();
                ushort targetedPlayer = reader.ReadUInt16();
                Character __askingPlayerCharacter = (Character)reader.ReadUInt16();
                Character ___targetedPlayerCharacter = (Character)reader.ReadUInt16();

                SetCharacter(askingPlayer, __askingPlayerCharacter, true);
                SetCharacter(targetedPlayer, ___targetedPlayerCharacter, true);
            }
        }
    }

    private void RefuseCharacterSwapInServer(object sender, MessageReceivedEventArgs e)
    {
        StopSwap();
    }

    public void StopSwap()
    {
        characterSwapPanelSender.SetActive(false);
        characterSwapPanelReceiver.SetActive(false);
        characterSwapPanelReceiverText.text = "";
        characterSwapPanelSenderText.text = "";
        askingSwapPlayerId = 0;
    }


    private void SetCharacter(ushort playerID, Character character, bool swap = false)
    {
        PlayerData player = RoomManager.Instance.actualRoom.playerList[playerID];
        int characterToInt = ((int)character / 10) - 1; // DE GEU LA SSE, a refaire

        CharacterListObj _listObj;

        switch (player.playerTeam)
        {
            case Team.red:
                _listObj = redTeamCharacterList[characterToInt];
                break;
            case Team.blue:
                _listObj = blueTeamCharacterList[characterToInt];
                break;
            default:
                print("ERROR");
                return;
        }

        if (linkPlayerCharacterListObj.ContainsKey(playerID))
        {
            if (!swap)
            {
                linkPlayerCharacterListObj[playerID].playerNameText.text = "";
            }
            linkPlayerCharacterListObj.Remove(playerID);
        }

        player.playerCharacter = character;
        player.IsReady = true;
        _listObj.playerNameText.text = player.Name;
        linkPlayerCharacterListObj.Add(playerID, _listObj);
    }


    private bool CheckIfCanLaunch()
    {
        foreach (KeyValuePair<ushort, PlayerData> p in RoomManager.Instance.actualRoom.playerList)
        {
            if (!p.Value.IsReady)
            {
                return false;
            }
        }

        // Décomenter pour forcer chaque équipe a avoir une shili >>

        //int shiliCount = 0;
        //foreach (PlayerData p in RoomManager.Instance.actualRoom.playerList.Values)
        //{
        //    if (p.playerCharacter == Character.Shili)
        //    {
        //        shiliCount++;
        //    }
        //}

        //if (shiliCount != 2)
        //{
        //    return false;
        //}

        //<<

        return true;
    }

    public void StartGame()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(RoomManager.Instance.actualRoom.ID);

            using (Message message = Message.Create(Tags.StartGame, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }
    }

}
