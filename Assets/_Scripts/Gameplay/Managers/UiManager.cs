using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using Sirenix.OdinInspector;
using UnityEngine.SceneManagement;
using DG.Tweening;

public class UiManager : MonoBehaviour
{
	private static UiManager _instance;
	public static UiManager Instance { get { return _instance; } }

	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI timer;
	[FoldoutGroup("GlobalUi")] public EndZoneUIGroup endZoneUIGroup;
	[FoldoutGroup("GlobalUi")] public GameObject trainPanel;
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI trainTimer;
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI allyScore;
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI ennemyScore;
	[FoldoutGroup("GlobalUi")] public UIAltarList uiAltarList;
	[FoldoutGroup("GlobalUi")] public GameObject echapMenu;
	[FoldoutGroup("GlobalUi")] public GameObject victoryPanel;
	[FoldoutGroup("GlobalUi")] public GameObject loosePanel;
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI endGameText;
	[FoldoutGroup("GlobalUi")] public EndGameScore endGameScore;
	[FoldoutGroup("GlobalUi")] public GameObject toDisableInEndGame;
	[FoldoutGroup("GlobalUi")] public ChatControl chat;
	[FoldoutGroup("GlobalUi")] public EndGameStats endGameStats;
	[FoldoutGroup("GlobalUi")] public Animator objectivesAnim;

	[FoldoutGroup("Minimap")] public Camera cameraMinimap;
	[FoldoutGroup("Minimap")] public GameObject minimapObj;
	[FoldoutGroup("Minimap")] public Image minimapKeyHelpImg;

	[FoldoutGroup("GeneralMessage")] [SerializeField] private Text generalMessage;
	[FoldoutGroup("GeneralMessage")] [SerializeField] private TextMeshProUGUI generalPoints;
	[FoldoutGroup("GeneralMessage")] [SerializeField] private Animator generalMessageAnim;
	[FoldoutGroup("GeneralMessage")] [SerializeField] private Animator generalPointsAnim;

	[FoldoutGroup("GeneralMessage")] [SerializeField] private GameObject waitingForPlayersPanel;

	[Header("GamePlayPart")]
	[Header("Status Icon")]
	[FoldoutGroup("StatusIcon")] public Image slowIcon;
	[FoldoutGroup("StatusIcon")] public Image spedUpIcon, silencedIcon, canalysingIcon, crouchedIcon, rootIcon, hiddenIcon;

	[Header("Spell Icons")]
	[FoldoutGroup("SpellIcon")] public GameObject spellBar;
	[FoldoutGroup("SpellIcon")] public IconUi firstSpell;
	[FoldoutGroup("SpellIcon")] public IconUi secondSpell, thirdSpell, tp, sprintIcon, autoAttackIcon, soulSpellIcon;

	[Header("Team Info")]
	[FoldoutGroup("TeamInfo")] public Image enemyRe, enemyWx, enemyLeng, teamRe, teamWx, teamLeng;
	[FoldoutGroup("TeamInfo")] public Color inViewBlueColor, inViewRedColor, outViewBlueColor, outViewRedColor, killedColor;

	[Header("Altars")]
	[FoldoutGroup("Altars")] [SerializeField] private List<Animator> teamImgAltar = new List<Animator>();
	[FoldoutGroup("Altars")] [SerializeField] private Animator altarContestUI;
    [FoldoutGroup("Altars")] [SerializeField] private GameObject altarUIPanel;

    [Header("Other Gameplay")]
	[FoldoutGroup("Other Gameplay")] public Camera mainCam;
	[FoldoutGroup("Other Gameplay")] public RectTransform radarRange;
	[FoldoutGroup("Other Gameplay")] public RectTransform nextAltarRadarIcon;
	[FoldoutGroup("Other Gameplay")] public RectTransform nextAltarRadarIconOnScreen;
	[FoldoutGroup("Other Gameplay")] public float pointerDistance = 8f;
	[FoldoutGroup("Other Gameplay")] public UIPingModule uIPingModule;
	[FoldoutGroup("Other Gameplay")] public Image tpFillImage;
	[FoldoutGroup("Other Gameplay")] public Image reviveFill;
	[FoldoutGroup("Other Gameplay")] public TextMeshProUGUI reviveText;
	[FoldoutGroup("Other Gameplay")] public GameObject reviveUI;
	[FoldoutGroup("Other Gameplay")] public GameObject feedbackDeath;
	[FoldoutGroup("Other Gameplay")] public RectTransform damageTakenFeedback;

	[FoldoutGroup("Ulti")] public GameObject prefabLifeBar;
	[FoldoutGroup("Ulti")] public Material blueColor, grayColor;
	[FoldoutGroup("Ulti")] public Transform parentLifeWX, parentLifeRE, parentLifeLENG;
	[FoldoutGroup("Ulti")] public TextMeshProUGUI curentUlti;
	List<Image> wxImgLife = new List<Image>();
	List<Image> reImgLife = new List<Image>();
	List<Image> lengImgLife = new List<Image>();

	public Transform parentWaypoint;

	private GameObject actualChar;
	private GameObject actualUnlockedAltar = null;
	private float radarRangeXDistanceFromZero = 0;
	private float radarRangeYDistanceFromZero = 0;

	[Header("Spec Mode")]
	[FoldoutGroup("SpecMode")] public SpecMode specMode;

	[Header("Misc")]
	[FoldoutGroup("Misc")] public GameObject DebuggerPanel;
	[FoldoutGroup("spellDescription")] public GameObject wholeTooltip;
	[FoldoutGroup("spellDescription")] public TextMeshProUGUI skillNameText, cooldownText, descriptionText;

	[Header("Annoncement")]
	[FoldoutGroup("Annoncement")] public Annoncement myAnnoncement;

	[SerializeField] AudioClip VictoryAudio, DefeatAudio;

	public Animator hitWXPanel;

	public SoulSpellSelector soulSpellSelector;
	public GameObject blurVolume;

	public CanvasGroup gameUI;

	public RectTransform parentCDFeedback;
	public GameObject prefabCDFeedback;

	[HideInInspector]
	public float currentCdDisplay = 0;


	private void Awake ()
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

		SpawnLifeBar(parentLifeWX, wxImgLife, Character.WuXin);
		SpawnLifeBar(parentLifeRE, reImgLife, Character.Re);
		SpawnLifeBar(parentLifeLENG, lengImgLife, Character.Leng);
	}

	void SpawnLifeBar ( Transform parent, List<Image> listImg, Character champ )
	{
        for (int i = 0; i < GameFactory.GetMaxLifeOfPlayer(champ); i++)
		{
			Image img = Instantiate(prefabLifeBar, parent).GetComponent<Image>();
			img.material = grayColor;
			listImg.Add(img);
		}
	}

	internal void AllPlayerJoinGameScene ()
	{
		soulSpellSelector.gameObject.SetActive(false);
		blurVolume.SetActive(false);

		gameUI.alpha = 1;
	}

	private void OnEnable ()
	{
		GameManager.Instance.OnPlayerDie += OnPlayerDie;
		GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;
		GameManager.Instance.OnPlayerGetDamage += OnPlayerTakeDamage;
		GameManager.Instance.OnPlayerGetHealed += OnPlayerGetHeal;
		GameManager.Instance.OnPlayerSpawn += OnPlayerSpawn;
	}

	private void OnDisable ()
	{
		GameManager.Instance.OnPlayerDie -= OnPlayerDie;
		GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
		GameManager.Instance.OnPlayerGetDamage -= OnPlayerTakeDamage;
		GameManager.Instance.OnPlayerSpawn -= OnPlayerSpawn;
		GameManager.Instance.OnPlayerGetHealed -= OnPlayerGetHeal;
	}

	private void Start ()
	{
		radarRangeXDistanceFromZero = radarRange.anchorMin.x * Screen.width;
		radarRangeYDistanceFromZero = radarRange.anchorMin.y * Screen.height;


		// A changer >>
		Team team = NetworkManager.Instance.GetLocalPlayer().playerTeam;

		string redTeamScore = RoomManager.Instance.actualRoom.scores[Team.red].ToString();
		string blueTeamScore = RoomManager.Instance.actualRoom.scores[Team.blue].ToString();


		if (team == Team.blue)
		{
			endGameScore.Init(blueTeamScore, redTeamScore);
		}
		else if (team == Team.red)
		{
			endGameScore.Init(redTeamScore, blueTeamScore);
		}

		StartCoroutine("tempCoroutine");
	}

	public void DisplaySoulSpell ()
	{

		waitingForPlayersPanel.SetActive(false);

		soulSpellSelector.gameObject.SetActive(true);
		soulSpellSelector.StartTimer();
		blurVolume.SetActive(true);

		gameUI.alpha = 0;
	}

    public void ActualiseLife(Character _champ)
    {
        int bonusLife = 0;

        ushort? id = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, _champ);

        if (id != null)
        {
            bonusLife += GameFactory.GetBonusHp((ushort)id);
        }

        switch (_champ)
        {
            case Character.WuXin:
                SetLife(GameFactory.GetLifePlayer(_champ), GameFactory.GetMaxLifeOfPlayer(_champ) + bonusLife, wxImgLife, parentLifeWX);
                break;

            case Character.Re:
                SetLife(GameFactory.GetLifePlayer(_champ), GameFactory.GetMaxLifeOfPlayer(_champ) + bonusLife, reImgLife, parentLifeRE);
                break;

            case Character.Leng:
                SetLife(GameFactory.GetLifePlayer(_champ), GameFactory.GetMaxLifeOfPlayer(_champ) + bonusLife, lengImgLife, parentLifeLENG);
                break;
        }
    }

    void OnPlayerSpawn ( ushort id )
	{
		if (GameFactory.IsOnMyTeam(id))
		{
			GetImageOfChamp(id).color = outViewBlueColor;
		}
		else
		{
			GetImageOfChamp(id).color = outViewRedColor;
		}

		if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
            ActualiseLife(RoomManager.Instance.actualRoom.playerList[id].playerCharacter);

            if (RoomManager.Instance.actualRoom.playerList[id] == NetworkManager.Instance.GetLocalPlayer())
			{
				if (GameFactory.IsOnMyTeam(id))
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

	void OnPlayerTakeDamage ( ushort id, ushort damage, ushort dealer )
	{
		if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
            ActualiseLife(RoomManager.Instance.GetPlayerData(id).playerCharacter);
        }
	}

	void OnPlayerGetHeal ( ushort id, ushort damage )
	{
		if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
            ActualiseLife(RoomManager.Instance.GetPlayerData(id).playerCharacter);
        }
	}

	void OnPlayerDie ( ushort idKilled, ushort idKiller )
	{
		//UI Minimap info
		if (!RoomManager.Instance.actualRoom.playerList.ContainsKey(idKilled))
		{
			return;
		}

		if (RoomManager.Instance.actualRoom.playerList[idKilled].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
            ActualiseLife(RoomManager.Instance.GetPlayerData(idKilled).playerCharacter);
        }

		GetImageOfChamp(idKilled).color = killedColor;
	}

	void OnPlayerViewChange ( ushort id, bool isVisible )
	{
		//actualise icon and color team
		if (GameManager.Instance.networkPlayers.ContainsKey(id) && GameManager.Instance.networkPlayers[id] != null)
		{
			Color myColor = Color.white;

			switch (isVisible)
			{
				case true:
					if (GameFactory.IsOnMyTeam(id))
					{
						myColor = inViewBlueColor;
					}
					else
					{
						myColor = inViewRedColor;
					}
					break;

				case false:
					if (GameFactory.IsOnMyTeam(id))
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

	internal void Revive ( bool state )
	{
		reviveUI.SetActive(state);
		spellBar.SetActive(!state);
		reviveFill.fillAmount = 1;
	}

	void SetLife ( int numberLife, int numberLifeMax, List<Image> imgs, Transform _parent)
	{
        foreach (Image img in imgs)
        {
            Destroy(img.gameObject);
        }
        imgs.Clear();

        for (int i = 1; i <= numberLifeMax; i++)
        {
            Image img = Instantiate(prefabLifeBar, _parent).GetComponent<Image>();

            if (i <= numberLife)
            {
                img.material = blueColor;
            }
            else
            {
                img.material = grayColor;
            }
            imgs.Add(img);
        }
	}

	List<Image> GetListImageOfTeamChamp ( ushort id )
	{
		switch (RoomManager.Instance.actualRoom.playerList[id].playerCharacter)
		{
			case Character.WuXin:
				return wxImgLife;

			case Character.Re:
				return reImgLife;

			case Character.Leng:
				return lengImgLife;
		}
		return null;
	}

	Image GetImageOfChamp ( ushort id )
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

	private void Update ()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			if (chat.isFocus)
			{
				chat.UnFocus();
			}
			else
			{
				SetEchapMenuState();
			}
		}


		if (Input.GetKeyDown(KeyCode.Return))
		{
			if (chat.isFocus)
			{
				if (chat.CheckMessage())
				{
					chat.Send();
				}
				else
				{
					chat.UnFocus();
				}
			}
			else
			{
				chat.Focus();
			}
		}

		if (Input.GetKey(KeyCode.LeftControl) && Input.GetKeyDown(KeyCode.F2))
		{
			DebuggerPanel.SetActive(!DebuggerPanel.activeInHierarchy);
		}
		if (Input.GetKeyDown(KeyCode.Tab))
		{
			minimapObj.SetActive(true);
			minimapKeyHelpImg.color = Color.green;
		}

		if (Input.GetKeyUp(KeyCode.Tab))
		{
			minimapKeyHelpImg.color = Color.white;
		}



		/*if (Input.GetKey(KeyCode.Tab))
		{
			cameraMinimap.Render();
		}
		if (Input.GetKeyUp(KeyCode.Tab))
		{
			minimapObj.SetActive(false);
		}*/


		currentCdDisplay += Time.deltaTime;
	}


	IEnumerator tempCoroutine()
	{
		yield return new WaitForSeconds(.5f);
		cameraMinimap.Render();
		StartCoroutine("tempCoroutine");

	}
	private void FixedUpdate ()
	{
		if (actualChar == null && GameFactory.GetLocalPlayerObj() != null)
		{
			actualChar = GameFactory.GetLocalPlayerObj().gameObject;
		}
	}

	public void SpawnCDFeedback ( Sprite _icon, float _time )
	{
		FeedbackSpellCDElement newCDFeedback = Instantiate(prefabCDFeedback, parentCDFeedback).GetComponent<FeedbackSpellCDElement>();

		newCDFeedback.GetComponent<RectTransform>().position = Input.mousePosition;
		newCDFeedback.Init(_icon, _time);
	}

	internal void UnlockNewAltar ( Altar altar )
	{
		actualUnlockedAltar = altar.gameObject;
		nextAltarRadarIcon.gameObject.SetActive(true);
	}

	List<Altar> altarCapture = new List<Altar>();
	public void OnAltarUnlock ( Altar _altar, Team _capturingTeam )
	{
		if (altarCapture.Contains(_altar))
		{
			return;
		}

		altarCapture.Add(_altar);
		uiAltarList.GainTeam(_capturingTeam);
	}

	public void SetAltarCaptureUIState(bool state, bool contest = false, int playercount = 1)
    {
        if (!state)
        {
            altarUIPanel.SetActive(false);
			return;
        }
        else
        {
            altarUIPanel.SetActive(true);
        }

        if (contest)
		{
            teamImgAltar[0].SetBool("IsIn", true);

            teamImgAltar[1].SetBool("IsIn", false); teamImgAltar[1].gameObject.SetActive(false);
            teamImgAltar[2].SetBool("IsIn", false); teamImgAltar[2].gameObject.SetActive(false);

            altarContestUI.gameObject.SetActive(true); altarContestUI.SetBool("IsIn", true);

        } else
        {
            altarContestUI.gameObject.SetActive(false);

            teamImgAltar[0].SetBool("IsIn", playercount >= 1);
            teamImgAltar[1].gameObject.SetActive(true); teamImgAltar[1].SetBool("IsIn", playercount >= 2);
            teamImgAltar[2].gameObject.SetActive(true); teamImgAltar[2].SetBool("IsIn", playercount >= 3);
        }
    }
	public void SetEchapMenuState ()
	{
		if (!echapMenu.activeSelf)
		{
			Cursor.lockState = CursorLockMode.None;
		}
		else
		{
			Cursor.lockState = CursorLockMode.Confined;
		}
		echapMenu.SetActive(!echapMenu.activeSelf);
		GameManager.Instance.menuOpen = echapMenu.activeSelf;
	}

	public void UpdateUiCooldownSpell ( En_SpellInput spell, float _timeRemaining, float _completeCd )
	{

		switch (spell)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.UpdateCooldown(_timeRemaining, _completeCd);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.UpdateCooldown(_timeRemaining, _completeCd);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.UpdateCooldown(_timeRemaining, _completeCd);
				break;
			case En_SpellInput.SoulSpell:
				soulSpellIcon.UpdateCooldown(_timeRemaining, _completeCd);
				break;
		}
	}

	public void SetupIcon ( En_SpellInput _spell, Sc_Spell _spellToTooltip )
	{
		switch (_spell)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.SetupIcon(_spell, _spellToTooltip);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.SetupIcon(_spell, _spellToTooltip);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.SetupIcon(_spell, _spellToTooltip);
				break;

			case En_SpellInput.SoulSpell:
				soulSpellIcon.SetupIcon(_spell, _spellToTooltip);
				break;
		}
	}

	internal void SpecJoinGameScene ()
	{
		waitingForPlayersPanel.SetActive(false);
	}

	public void CantCastFeedback ( En_SpellInput _spellInput )
	{
		switch (_spellInput)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.CantCastFeedback();
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.CantCastFeedback();
				break;

			case En_SpellInput.Click:
				autoAttackIcon.CantCastFeedback();
				break;

			case En_SpellInput.SoulSpell:
				soulSpellIcon.CantCastFeedback();
				break;
		}
	}

	public void UpdateSpellIconState ( En_SpellInput _spellInput, En_IconStep _step )
	{
		switch (_spellInput)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.UpdateSpellStep(_step);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.UpdateSpellStep(_step);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.UpdateSpellStep(_step);
				break;

			case En_SpellInput.SoulSpell:
				soulSpellIcon.UpdateSpellStep(_step);
				break;
		}
	}


	public void StatusUpdate ( En_CharacterState _currentState )
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

	public void DisplayGeneralPoints ( Team team, int value )
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

	public void OpenSpecMode ()
	{
		specMode.gameObject.SetActive(true);
	}

	public void CloseSpecMode ()
	{
		specMode.gameObject.SetActive(false);
	}

	public void OpenSettings ()
	{
		SceneManager.LoadScene("Settings", LoadSceneMode.Additive);
	}
	public void EndGamePanel ( bool victory = false, Team team = Team.none, bool wuxinKilled = false )
	{
		if (victory)
		{
			AudioManager.Instance.Play2DAudio(VictoryAudio);
		}
		else
		{
			AudioManager.Instance.Play2DAudio(DefeatAudio);
		}

		if (wuxinKilled)
		{
			endGameText.text = "Wu Xin Killed";
		}
		else
		{
			endGameText.text = "End Zone captured";
		}

		victoryPanel.SetActive(victory);
		loosePanel.SetActive(!victory);
		endGameText.gameObject.SetActive(true);
		endGameScore.gameObject.SetActive(true);
		endGameScore.EndGame(team);

		toDisableInEndGame.SetActive(false);
	}

	public void InitEndGameStats ()
	{
		endGameStats.gameObject.SetActive(true);
		endGameStats.Init();
	}

	public void OnDamageTaken ()
	{
		Image _temp = damageTakenFeedback.GetComponent<Image>();
		_temp.color = new Vector4(255, 255, 255, 255);
		_temp.DOColor(new Vector4(255, 255, 255, 0), 1f);

		int _xSize = UnityEngine.Random.Range(0, 1);
		int _ySize = UnityEngine.Random.Range(0, 1);

		if (_xSize > 0 && _ySize > 0)
			damageTakenFeedback.localScale = new Vector2(1, 1);
		else if (_xSize < 0 && _ySize < 0)
			damageTakenFeedback.localScale = new Vector2(-1, -1);
		else if (_xSize < 0 && _ySize > 0)
			damageTakenFeedback.localScale = new Vector2(1, -1);
		else if (_xSize < 0 && _ySize > 0)
			damageTakenFeedback.localScale = new Vector2(-1, 1);

	}

	public void StartTutorial ()
	{
		waitingForPlayersPanel.SetActive(false);
	}

}
