﻿using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using Sirenix.OdinInspector;
using UnityEngine.SceneManagement;

public class UiManager : MonoBehaviour
{
    private static UiManager _instance;
    public static UiManager Instance { get { return _instance; } }

    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI timer;
    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI allyScore;
    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI ennemyScore;
    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI round;
    [FoldoutGroup("GlobalUi")] public GameObject echapMenu;
    [FoldoutGroup("GlobalUi")] public GameObject victoryPanel;
    [FoldoutGroup("GlobalUi")] public GameObject loosePanel;
    [FoldoutGroup("GlobalUi")] public EndGameScore endGameScore;
    [FoldoutGroup("GlobalUi")] public GameObject toDisableInEndGame;


    [FoldoutGroup("GeneralMessage")] [SerializeField] private TextMeshProUGUI generalMessage;
    [FoldoutGroup("GeneralMessage")] [SerializeField] private TextMeshProUGUI generalPoints;
    [FoldoutGroup("GeneralMessage")] [SerializeField] private Animator generalMessageAnim;
    [FoldoutGroup("GeneralMessage")] [SerializeField] private Animator generalPointsAnim;
    [FoldoutGroup("GeneralMessage")] [SerializeField] private GameObject waitingForPlayersPanel;

    [FoldoutGroup("GeneralMessage")] public float generalMessageAnimTime = 3;
    private List<string> generalMessageList = new List<string>();
    private bool waitForGenMessageAnimEnd = false;

    [SerializeField] Image brumeFilter;

    [Header("GamePlayPart")]
    [Header("Status Icon")]
    [FoldoutGroup("StatusIcon")] public Image slowIcon;
    [FoldoutGroup("StatusIcon")] public Image spedUpIcon, silencedIcon, canalysingIcon, crouchedIcon, rootIcon, hiddenIcon;

    [Header("Spell Icons")]
    [FoldoutGroup("SpellIcon")] public IconUi firstSpell;
    [FoldoutGroup("SpellIcon")] public IconUi secondSpell, thirdSpell, sprintIcon, autoAttackIcon, wardIcon;

    [Header("Team Info")]
    [FoldoutGroup("TeamInfo")] public Image enemyRe, enemyWx, enemyLeng, teamRe, teamWx, teamLeng;
    [FoldoutGroup("TeamInfo")] public Color inViewBlueColor, inViewRedColor, outViewBlueColor, outViewRedColor, killedColor;
    [FoldoutGroup("TeamInfo")] public Image lifeYang, lifeShili, lifeYin;
    [FoldoutGroup("TeamInfo")] public List<AllyIconUI> allyIconUIs = new List<AllyIconUI>();

    [Header("Spec Mode")]
    [FoldoutGroup("SpecMode")] public SpecMode specMode;
    [Header("Misc")]
    [FoldoutGroup("Misc")] public GameObject DebuggerPanel;

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

        //disable de base
        teamWx.color = killedColor;
        teamRe.color = killedColor;
        teamLeng.color = killedColor;

        enemyWx.color = killedColor;
        enemyRe.color = killedColor;
        enemyLeng.color = killedColor;

        lifeShili.fillAmount = 0;
        lifeYang.fillAmount = 0;
        lifeYin.fillAmount = 0;
    }

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
        GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;
        GameManager.Instance.OnPlayerGetDamage += OnPlayerTakeDamage;
        GameManager.Instance.OnPlayerSpawn += OnPlayerSpawn;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
        GameManager.Instance.OnPlayerGetDamage -= OnPlayerTakeDamage;
        GameManager.Instance.OnPlayerSpawn -= OnPlayerSpawn;
    }

    private void Start()
    {
        // A changer >>
        Team team = NetworkManager.Instance.GetLocalPlayer().playerTeam;
        string redTeamScore = RoomManager.Instance.actualRoom.scores[Team.red].ToString();
        string blueTeamScore = RoomManager.Instance.actualRoom.scores[Team.blue].ToString();


        if (team == Team.blue)
        {
            allyScore.color = Color.blue;
            ennemyScore.color = Color.red;
            endGameScore.Init(Color.blue, Color.red, blueTeamScore, redTeamScore);
        }
        else if (team == Team.red)
        {
            allyScore.color = Color.red;
            ennemyScore.color = Color.blue;

            endGameScore.Init(Color.red, Color.blue, redTeamScore, blueTeamScore);
        }

        round.text = "Round : " + RoomManager.Instance.roundCount;
        // <<
    }

    void OnPlayerSpawn(ushort id)
    {
        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == Team.blue)
        {
            GetImageOfChamp(id).color = outViewBlueColor;
        }
        else
        {
            GetImageOfChamp(id).color = outViewRedColor;
        }

        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            GetLifeImageOfTeamChamp(id).fillAmount = 1;

            if (RoomManager.Instance.actualRoom.playerList[id] == NetworkManager.Instance.GetLocalPlayer())
            {
                if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == Team.blue)
                {
                    GetImageOfChamp(id).color = inViewBlueColor;
                }
                else
                {
                    GetImageOfChamp(id).color = inViewRedColor;
                }
            }
        }
    }

    void OnPlayerTakeDamage(ushort id, ushort damage)
    {
        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            GetLifeImageOfTeamChamp(id).fillAmount = (float)GameManager.Instance.networkPlayers[id].liveHealth
                / GameFactory.GetMaxLifeOfPlayer(id);
        }
    }

    void OnPlayerDie(ushort idKilled, ushort idKiller)
    {
        //
        if (idKilled == idKiller)
        {
            DisplayGeneralMessage("You slain an ennemy");
            //play son kill

        }


        //UI Minimap info
        if (RoomManager.Instance.actualRoom.playerList[idKilled].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            GetLifeImageOfTeamChamp(idKilled).fillAmount = 0;

        }

        GetImageOfChamp(idKilled).color = killedColor;
    }

    void OnPlayerViewChange(ushort id, bool isVisible)
    {
        if (GameManager.Instance.networkPlayers.ContainsKey(id) && GameManager.Instance.networkPlayers[id] != null)
        {
            Color myColor = Color.white;

            switch (isVisible)
            {
                case true:
                    if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == Team.blue)
                    {
                        myColor = inViewBlueColor;
                    }
                    else{
                        myColor = inViewRedColor;
                    }
                    break;

                case false:
                    if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == Team.blue)
                    {
                        myColor = outViewBlueColor;
                    }
                    else
                    {
                        myColor = outViewRedColor;
                    }
                    break;
            }

            GetImageOfChamp(id).color = myColor;
        }
        else
        {
            //joueur est mort
            GetImageOfChamp(id).color = killedColor;
        }
    }

    Image GetLifeImageOfTeamChamp(ushort id)
    {
        switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
        {
            case Character.WuXin:
                return lifeShili;

            case Character.Re:
                return lifeYang;

            case Character.Leng:
                return lifeYin;
        }
        return null;
    }

    Image GetImageOfChamp(ushort id)
    {
        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
            {
                case Character.WuXin:
                    return teamWx;

                case Character.Re:
                    return teamRe;

                case Character.Leng:
                    return teamLeng;
            }
        }
        else
        {
            switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
            {
                case Character.WuXin:
                    return enemyWx;

                case Character.Re:
                    return enemyRe;

                case Character.Leng:
                    return enemyLeng;
            }
        }
        return null;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SetEchapMenuState();
        }
    }
    private void FixedUpdate()
    {
        if (generalMessageList.Count > 0 && !waitForGenMessageAnimEnd)
        {
            StartCoroutine(GeneralMessage());
        }
    }

    public void SetEchapMenuState()
    {
        echapMenu.SetActive(!echapMenu.activeInHierarchy);
    }

    public void UpdateUiCooldownSpell(En_SpellInput spell, float _time, float _completeCd)
    {

        switch (spell)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.UpdateFillAmount(_time, _completeCd);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.UpdateFillAmount(_time, _completeCd);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.UpdateFillAmount(_time, _completeCd);
                break;

            case En_SpellInput.Maj:
                sprintIcon.UpdateFillAmount(_time, _completeCd);
                break;

            case En_SpellInput.Click:
                autoAttackIcon.UpdateFillAmount(_time, _completeCd);
                break;
            case En_SpellInput.Ward:
                wardIcon.UpdateFillAmount(_time, _completeCd);
                break;
        }
    }

    public void SetupIcon(Sc_Spell _spellAttached, En_SpellInput _input)
    {
        switch (_input)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.SetSprite(_spellAttached.spellIcon);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.SetSprite(_spellAttached.spellIcon);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.SetSprite(_spellAttached.spellIcon);
                break;

            case En_SpellInput.Maj:
                break;

            case En_SpellInput.Click:
                autoAttackIcon.SetSprite(_spellAttached.spellIcon);
                break;
            case En_SpellInput.Ward:
                wardIcon.SetSprite(_spellAttached.spellIcon);
                break;
        }
    }

    public void LinkInputName(En_SpellInput _input, string _name)
    {
        switch (_input)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.SetupInputName(_name);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.SetupInputName(_name);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.SetupInputName(_name);
                break;

            case En_SpellInput.Maj:
                break;

            case En_SpellInput.Click:
                autoAttackIcon.SetupInputName(_name);
                break;
            case En_SpellInput.Ward:
                wardIcon.SetupInputName(_name);
                break;
        }
    }

    internal void AllPlayerJoinGameScene()
    {
        waitingForPlayersPanel.SetActive(false);
    }

    public void UpdateChargesUi(int _charges, En_SpellInput _spellInput)
    {
        switch (_spellInput)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.UpdatesChargesAmont(_charges);
                if (_charges > 0)
                    firstSpell.HideIcon(false);
                else
                    firstSpell.HideIcon(true);

                break;
            case En_SpellInput.SecondSpell:
                secondSpell.UpdatesChargesAmont(_charges);
                if (_charges > 0)
                    secondSpell.HideIcon(false);
                else
                    secondSpell.HideIcon(true);
                break;
            case En_SpellInput.ThirdSpell:
                thirdSpell.UpdatesChargesAmont(_charges);
                if (_charges > 0)
                    thirdSpell.HideIcon(false);
                else
                    thirdSpell.HideIcon(true);
                break;
            case En_SpellInput.Click:
                autoAttackIcon.UpdatesChargesAmont(_charges);
                if (_charges > 0)
                    autoAttackIcon.HideIcon(false);
                else
                    autoAttackIcon.HideIcon(true);
                break;
            case En_SpellInput.Ward:
                wardIcon.UpdatesChargesAmont(_charges);
                if (_charges > 0)
                    wardIcon.HideIcon(false);
                else
                    wardIcon.HideIcon(true);
                break;

        }
    }

    public void StatusUpdate(En_CharacterState _currentState)
    {
        if ((_currentState & En_CharacterState.Silenced) != 0)
            silencedIcon.gameObject.SetActive(true);
        else
            silencedIcon.gameObject.SetActive(false);

        if ((_currentState & En_CharacterState.Slowed) != 0)
            slowIcon.gameObject.SetActive(true);
        else
            slowIcon.gameObject.SetActive(false);

        if ((_currentState & En_CharacterState.SpedUp) != 0)
            spedUpIcon.gameObject.SetActive(true);
        else
            spedUpIcon.gameObject.SetActive(false);

        if ((_currentState & En_CharacterState.Root) != 0)
            rootIcon.gameObject.SetActive(true);
        else
            rootIcon.gameObject.SetActive(false);

        if ((_currentState & En_CharacterState.Canalysing) != 0)
            canalysingIcon.gameObject.SetActive(true);
        else
            canalysingIcon.gameObject.SetActive(false);

        if ((_currentState & En_CharacterState.Crouched) != 0)
            crouchedIcon.gameObject.SetActive(true);
        else
            crouchedIcon.gameObject.SetActive(false);


        if ((_currentState & En_CharacterState.Hidden) != 0)
            hiddenIcon.gameObject.SetActive(true);
        else
            hiddenIcon.gameObject.SetActive(false);
    }

    public void SetAlphaBrume(float value)
    {
        brumeFilter.color = new Color(brumeFilter.color.r, brumeFilter.color.g, brumeFilter.color.b, value);
    }

    public void DisplayGeneralMessage(string value)
    {
        generalMessageList.Add(value);
    }

    IEnumerator GeneralMessage()
    {
        waitForGenMessageAnimEnd = true;
        generalMessage.text = generalMessageList[0];
        generalMessageAnim.Play("GenMessage");

        yield return new WaitForSeconds(generalMessageAnimTime);

        generalMessageList.RemoveAt(0);

        if (generalMessageList.Count == 0)
        {
            waitForGenMessageAnimEnd = false;
        }
        else
        {
            StartCoroutine(GeneralMessage());
        }

    }

    public void DisplayGeneralPoints(Team team, int value)
    {
        generalPoints.text = "+" + value;

        if (team == Team.blue)
        {
            generalPoints.color = Color.blue;
        }
        else if (team == Team.red)
        {
            generalPoints.color = Color.red;
        }

        generalPointsAnim.Play("GenPoints");
    }

    public void OpenSpecMode()
    {
        specMode.gameObject.SetActive(true);
    }

    public void CloseSpecMode()
    {
        specMode.gameObject.SetActive(false);
    }

    public void OpenSettings()
    {
        SceneManager.LoadScene("Settings", LoadSceneMode.Additive);
    }
    public void EndGamePanel(bool victory = false, ushort newPoints = 0, Team team = Team.none)
    {
        victoryPanel.SetActive(victory);
        loosePanel.SetActive(!victory);
        endGameScore.gameObject.SetActive(true);
        endGameScore.EndGame(newPoints, team);

        toDisableInEndGame.SetActive(false);
    }

    public void PickSoul(Character character)
    {
        int characterToInt = ((ushort)character / 10) - 1;

        allyIconUIs[characterToInt].SetPickSoul(true);
    }
    public void ResetPickSoul()
    {
        foreach (AllyIconUI item in allyIconUIs)
        {
            item.SetPickSoul(false);
        }

    }

}
