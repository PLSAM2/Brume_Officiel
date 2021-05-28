using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using static GameData;

public class ChampSelectManager : SerializedMonoBehaviour
{
    private static ChampSelectManager _instance;
    public static ChampSelectManager Instance { get { return _instance; } }

    public List<PlayerTeamElement> redTeamPlayerElement = new List<PlayerTeamElement>();
    public List<PlayerTeamElement> blueTeamPlayerElement = new List<PlayerTeamElement>();

    public List<PlayerTeamElement> charactersElement = new List<PlayerTeamElement>();

    public GameObject startButton;
    public Text roundText;

    private Dictionary<ushort, PlayerTeamElement> linkPlayerCharacterListObj = new Dictionary<ushort, PlayerTeamElement>(); // character 
    private Dictionary<ushort, PlayerTeamElement> linkPlayerTeamPlayerElement = new Dictionary<ushort, PlayerTeamElement>(); // player list

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

        NetworkManager.Instance.OnPlayerQuit += OnPlayerQuit;
        RoomManager.Instance.client.MessageReceived += MessageReceived;

        PlayerPrefs.SetInt("currentKill", 0);
        PlayerPrefs.SetInt("currentDamage", 0);
        PlayerPrefs.SetInt("currentDeath", 0);
        PlayerPrefs.SetInt("currentCapture", 0);
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.None;
    }

    private void InitChampSelect()
    {
        roundText.text = "Round : " + RoomManager.Instance.roundCount;


        int redTeamCounter = 0;
        int blueTeamCounter = 0;

        foreach (PlayerData p in RoomManager.Instance.actualRoom.playerList.Values)
        {
            PlayerTeamElement _teamElement = null;

            switch (p.playerTeam)
            {
                case Team.none:
                    return;
                case Team.red:
                    _teamElement = redTeamPlayerElement[redTeamCounter];
                    redTeamCounter++;
                    break;
                case Team.blue:
                    _teamElement = blueTeamPlayerElement[blueTeamCounter];

                    blueTeamCounter++;
                    break;
                case Team.spectator:
                    continue;
                default: throw new Exception("NO TEAM");
            }
            _teamElement.SetStatut(PlayerTeamElement.ChampSelectStatut.pick);
            linkPlayerTeamPlayerElement.Add(p.ID, _teamElement);
            _teamElement.Init(p);
        }
    }

    private void OnDisable()
    {
        NetworkManager.Instance.OnPlayerQuit -= OnPlayerQuit;
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
        if (character == NetworkManager.Instance.GetLocalPlayer().playerCharacter || NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
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

        linkPlayerTeamPlayerElement[_playerID].SetStatut(PlayerTeamElement.ChampSelectStatut.confirme);

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
        if (askingSwapPlayerId != 0)
        {
            return;
        }

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _playerID = reader.ReadUInt16(); // joueur demandant le swap
                ushort _targetedID = reader.ReadUInt16(); // joueur target par le swap
                Character _character = (Character)reader.ReadUInt16();

                askingSwapPlayerId = _playerID;

                if (_targetedID == NetworkManager.Instance.GetLocalPlayer().ID)
                {
                    characterSwapPanelReceiver.SetActive(true);
                    characterSwapPanelSender.SetActive(false);
                    characterSwapPanelReceiverText.text = RoomManager.Instance.GetPlayerData(_playerID).Name + " want to swap " + _character.ToString() + " with you";
                }
                else if (_playerID == NetworkManager.Instance.GetLocalPlayer().ID)
                {
                    characterSwapPanelSender.SetActive(true);
                    characterSwapPanelReceiver.SetActive(false);
                    characterSwapPanelSenderText.text = "Asking " + RoomManager.Instance.GetPlayerData(_targetedID).Name + " to swap";
                }

                linkPlayerCharacterListObj[_playerID].SetSwapIcon(true);
                linkPlayerCharacterListObj[_targetedID].SetSwapIcon(true);
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

        StopSwap();
    }

    private void RefuseCharacterSwapInServer(object sender, MessageReceivedEventArgs e)
    {
        StopSwap();
    }

    public void StopSwap()
    {
        foreach (PlayerTeamElement charList in linkPlayerCharacterListObj.Values)
        {
            charList.SetSwapIcon(false);
        }

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

        PlayerTeamElement _characterObj;

        if (player.playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            _characterObj = charactersElement[characterToInt];

            if (linkPlayerCharacterListObj.ContainsKey(playerID))
            {
                if (!swap)
                {
                    linkPlayerCharacterListObj[playerID].OnPlayerLeave();
                }
                linkPlayerCharacterListObj.Remove(playerID);
            }
            _characterObj.Init(player, true);
            linkPlayerCharacterListObj.Add(playerID, _characterObj);
        }

        player.playerCharacter = character;
        player.IsReady = true;
    }


    private bool CheckIfCanLaunch()
    {
        foreach (KeyValuePair<ushort, PlayerData> p in RoomManager.Instance.actualRoom.playerList)
        {
            if (p.Value.playerTeam == Team.spectator)
            {
                continue;
            }

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

    public void OpenSetting()
    {
        SceneManager.LoadScene("Settings", LoadSceneMode.Additive);
    }

    private void OnPlayerQuit(PlayerData obj)
    {
        if (linkPlayerTeamPlayerElement.ContainsKey(obj.ID))
        {
            linkPlayerTeamPlayerElement[obj.ID].OnPlayerLeave();
            linkPlayerTeamPlayerElement.Remove(obj.ID);
        }

        if (linkPlayerCharacterListObj.ContainsKey(obj.ID))
        {
            linkPlayerCharacterListObj[obj.ID].OnPlayerLeave();
            linkPlayerCharacterListObj.Remove(obj.ID);
        }

    }

    public void LeaveGame()
    {
        RoomManager.Instance.QuitGame();
    }
}
