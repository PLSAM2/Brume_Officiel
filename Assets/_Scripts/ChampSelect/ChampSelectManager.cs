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
    [Header("Ref")]
    public List<PlayerTeamElement> playerElement = new List<PlayerTeamElement>();

    public List<ChampionSlot> charactersElement = new List<ChampionSlot>();
    public List<GameObject> charactersPanel = new List<GameObject>();

    public GameObject startButton;
    public GameObject selectButton;
    public Text roundText;

    private Dictionary<ushort, ChampionSlot> linkPlayerCharacterListObj = new Dictionary<ushort, ChampionSlot>(); // character 
    private Dictionary<ushort, PlayerTeamElement> linkPlayerElement = new Dictionary<ushort, PlayerTeamElement>(); // player list

    [Header("Swap")]
    public GameObject characterSwapPanelReceiver;
    public GameObject characterSwapPanelSender;
    public TextMeshProUGUI characterSwapPanelReceiverText;
    public TextMeshProUGUI characterSwapPanelSenderText;
    private ushort askingSwapPlayerId = 0;

    public Character pickChar = Character.none;

    public GameObject wxImg, reImg, lengImg;

    public List<Parallax> allParallax = new List<Parallax>();

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

        foreach(Parallax myParallax in allParallax)
        {
            myParallax.enabled = false;
        }
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.None;
    }

    private void InitChampSelect()
    {
        roundText.text = "Round : " + RoomManager.Instance.roundCount;

        int playerCount = 0;

        foreach (PlayerData p in RoomManager.Instance.actualRoom.playerList.Values)
        {
            if (p.playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                PlayerTeamElement _teamElement = null;

                _teamElement = playerElement[playerCount];
                playerCount++;

                _teamElement.SetStatut(PlayerTeamElement.ChampSelectStatut.pick);
                linkPlayerElement.Add(p.ID, _teamElement);
                _teamElement.Init(p);
            }
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



    public void PickCharacter(GameData.Character character, ChampionSlot cs)
    {
        int characterToInt = ((int)character / 10) - 1; // meh

        foreach (GameObject item in charactersPanel)
        {
            item.SetActive(false);
        }

        charactersPanel[characterToInt].SetActive(true);

        foreach (ChampionSlot item in charactersElement)
        {
            if (cs == item)
            {
                continue;
            }
            item.UnPick();
        }
        selectButton.SetActive(true);

        foreach (PlayerData pd in RoomManager.Instance.actualRoom.playerList.Values)
        {
            if (pd.playerCharacter == character)
            {
                selectButton.SetActive(true);
            }
        }

        wxImg.SetActive(character == Character.WuXin);
        reImg.SetActive(character == Character.Re);
        lengImg.SetActive(character == Character.Leng);

        pickChar = character;

        foreach (Parallax myParallax in allParallax)
        {
            myParallax.enabled = true;
        }
    }

    public void SelectChar()
    {
        if (pickChar == NetworkManager.Instance.GetLocalPlayer().playerCharacter || NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
        {
            return;
        }


        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)pickChar);

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
        //foreach (ChampionSlot charList in linkPlayerCharacterListObj.Values)
        //{
        //    charList.SetSwapIcon(false);
        //}

        characterSwapPanelSender.SetActive(false);
        characterSwapPanelReceiver.SetActive(false);
        characterSwapPanelReceiverText.text = "";
        characterSwapPanelSenderText.text = "";
        askingSwapPlayerId = 0;
    }


    private void SetCharacter(ushort playerID, Character character, bool swap = false)
    {
        PlayerData player = RoomManager.Instance.actualRoom.playerList[playerID];
        int characterToInt = ((int)character / 10) - 1; // meh

        ChampionSlot _characterSlot;
        PlayerTeamElement _playerTeamElement;
        if (player.playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            _characterSlot = charactersElement[characterToInt];

            if (linkPlayerCharacterListObj.ContainsKey(playerID))
            {
                if (!swap)
                {
                    linkPlayerCharacterListObj[playerID].OnPlayerLeave();
                }
                linkPlayerCharacterListObj.Remove(playerID);
            }



            _playerTeamElement = linkPlayerElement[playerID];

            _playerTeamElement.SetStatut(PlayerTeamElement.ChampSelectStatut.ready);
            _playerTeamElement.PickCharacter(character);

            if (character == pickChar)
            {
                selectButton.SetActive(false);
            }


            _characterSlot.Pick(playerID);
            linkPlayerCharacterListObj.Add(playerID, _characterSlot);
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
        if (linkPlayerElement.ContainsKey(obj.ID))
        {
            linkPlayerElement[obj.ID].OnPlayerLeave();
            linkPlayerElement.Remove(obj.ID);
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
