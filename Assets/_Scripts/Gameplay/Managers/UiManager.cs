using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using Sirenix.OdinInspector;

public class UiManager : MonoBehaviour
{
    private static UiManager _instance;
    public static UiManager Instance { get { return _instance; } }



    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI timer;
    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI allyScore;
    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI ennemyScore;
    [FoldoutGroup("GlobalUi")] public TextMeshProUGUI round;


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
    [FoldoutGroup("StatusIcon")] public Image stunIcon;
    [FoldoutGroup("StatusIcon")] public Image slowIcon, spedUpIcon, silencedIcon,canalysingIcon, crouchedIcon;

    [Header("Spell Icons")]
    [FoldoutGroup("SpellIcon")] public IconUi firstSpell;
    [FoldoutGroup("SpellIcon")] public IconUi secondSpell, thirdSpell, sprintIcon, autoAttackIcon, wardIcon;

    [Header("Minimap")]
    [FoldoutGroup("Minimap")] public Image enemyYang, enemyShili, enemyYin;
    [FoldoutGroup("Minimap")] public Color inViewColor, outViewColor, killedColor;
    [FoldoutGroup("Minimap")] public Sprite champIcon, champKilledIcon;

    [Header("Team Info")]
    [FoldoutGroup("TeamInfo")] public Image teamYang, teamShili, teamYin;
    [FoldoutGroup("TeamInfo")] public Image lifeYang, lifeShili, lifeYin;


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
        GameFactory.ChangeIconMinimap(enemyShili, null, killedColor);
        GameFactory.ChangeIconMinimap(enemyYang, champKilledIcon, killedColor);
        GameFactory.ChangeIconMinimap(enemyYin, champKilledIcon, killedColor);

        lifeShili.fillAmount = 0;

        teamYang.sprite = champKilledIcon;
        lifeYang.fillAmount = 0;

        teamYin.sprite = champKilledIcon;
        lifeYin.fillAmount = 0;
    }

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
        GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;
        GameManager.Instance.OnPlayerGetDamage += OnPlayerTakeDamage;
        GameManager.Instance.OnPlayerRespawn += OnPlayerRespawn;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
        GameManager.Instance.OnPlayerGetDamage -= OnPlayerTakeDamage;
        GameManager.Instance.OnPlayerRespawn -= OnPlayerRespawn;
    }

    private void Start()
    {
        // A changer >>
        Team team = RoomManager.Instance.GetLocalPlayer().playerTeam;

        if (team == Team.blue)
        {
            allyScore.color = Color.blue;
            ennemyScore.color = Color.red;
        }
        else if (team == Team.red)
        {
            allyScore.color = Color.red;
            ennemyScore.color = Color.blue;
        }

        round.text = "Round : " + RoomManager.Instance.roundCount;
        // <<
    }

    void OnPlayerRespawn(ushort id)
    {
        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            GetImageOfTeamChamp(id).sprite = champIcon;
            GetLifeImageOfTeamChamp(id).fillAmount = 1;
        }
        else
        {
            GameFactory.ChangeIconMinimap(GetImageOfEnemyChamp(id), champIcon, outViewColor);
        }
    }

    void OnPlayerTakeDamage(ushort id, ushort damage)
    {
        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            GetLifeImageOfTeamChamp(id).fillAmount = (float) GameManager.Instance.networkPlayers[id].liveHealth 
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

        //Kill feed a faire


        //UI Minimap info
        if (RoomManager.Instance.actualRoom.playerList[idKilled].playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            GetImageOfTeamChamp(idKilled).sprite = champKilledIcon;
            GetLifeImageOfTeamChamp(idKilled).fillAmount = 0;
        }
        else //enemy
        {
            GameFactory.ChangeIconMinimap(GetImageOfEnemyChamp(idKilled), champKilledIcon, killedColor);
        }
    }

    void OnPlayerViewChange(ushort id, bool isVisible)
    {
        if(RoomManager.Instance.actualRoom.playerList[id].playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }

        if (GameManager.Instance.networkPlayers.ContainsKey(id) && GameManager.Instance.networkPlayers[id] != null)
        {
            Sprite currentSprite = champIcon;

            if (RoomManager.Instance.actualRoom.playerList[id].playerCharacter == Character.Shili)
            {
                currentSprite = null;
            }

            switch (isVisible)
            {
                case true:
                    GameFactory.ChangeIconMinimap(GetImageOfEnemyChamp(id), currentSprite, inViewColor);
                    break;

                case false:
                    GameFactory.ChangeIconMinimap(GetImageOfEnemyChamp(id), currentSprite, outViewColor);
                    break;
            }
        }
        else
        {
            //joueur est mort
            GameFactory.ChangeIconMinimap(GetImageOfEnemyChamp(id), champKilledIcon, killedColor);
        }
    }

    Image GetLifeImageOfTeamChamp(ushort id)
    {
        switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
        {
            case Character.Shili:
                return lifeShili;

            case Character.Yang:
                return lifeYang;

            case Character.Yin:
                return lifeYin;
        }
        return null;
    }

    Image GetImageOfTeamChamp(ushort id)
    {
        switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
        {
            case Character.Shili:
                return teamShili;

            case Character.Yang:
                return teamYang;

            case Character.Yin:
                return teamYin;
        }
        return null;
    }


    Image GetImageOfEnemyChamp(ushort id)
    {
        switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
        {
            case Character.Shili:
                return enemyShili;

            case Character.Yang:
                return enemyYang;

            case Character.Yin:
                return enemyYin;
        }
        return null;
    }

    private void FixedUpdate()
    {
        if (generalMessageList.Count > 0 && !waitForGenMessageAnimEnd)
        {
            StartCoroutine(GeneralMessage());
        }
    }

    public void UpdateUiCooldownSpell(En_SpellInput spell, float _time, float _completeCd)
    {

        switch (spell)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, firstSpell, .2f);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, secondSpell, .2f);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, thirdSpell, .2f);
                break;

            case En_SpellInput.Maj:
                sprintIcon.UpdateFillAmount( _time, _completeCd);
                break;

            case En_SpellInput.Click:
                autoAttackIcon.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, autoAttackIcon, 0.05f);
                break;
            case En_SpellInput.Ward:
                wardIcon.UpdateFillAmount(_time, _completeCd);
                CheckBeReady(_time, wardIcon, 0.05f);
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

    internal void AllPlayerJoinGameScene()
    {
        waitingForPlayersPanel.SetActive(false);
    }

    void CheckBeReady(float _actualTime, IconUi _iconToPrep, float _timeToCheckShow)
    {
        if (_actualTime <= 0.2f)
            _iconToPrep.BeReady(true, _timeToCheckShow);
        else
            _iconToPrep.BeReady(false, _timeToCheckShow);
    }

    public void UpdateChargesUi(int _charges, En_SpellInput _spellInput)
	{
        switch(_spellInput)
		{
            case En_SpellInput.FirstSpell:
                firstSpell.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.SecondSpell:
                secondSpell.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.ThirdSpell:
                thirdSpell.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.Click:
                autoAttackIcon.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.Ward:
                wardIcon.UpdatesChargesAmont(_charges);
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

		if ((_currentState & En_CharacterState.SpedUp)!= 0)
			spedUpIcon.gameObject.SetActive(true);
		else
			spedUpIcon.gameObject.SetActive(false);

		if ((_currentState & En_CharacterState.Stunned)!= 0)
			stunIcon.gameObject.SetActive(true);
		else
			stunIcon.gameObject.SetActive(false);

		if ((_currentState & En_CharacterState.Canalysing) != 0)
			canalysingIcon.gameObject.SetActive(true);
		else
			canalysingIcon.gameObject.SetActive(false);

        if ((_currentState & En_CharacterState.Crouched) != 0)
            crouchedIcon.gameObject.SetActive(true);
        else
            crouchedIcon.gameObject.SetActive(false);
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
        } else
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
}
