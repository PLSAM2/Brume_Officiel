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
	[FoldoutGroup("SpellIcon")] public IconUi firstSpell;
	[FoldoutGroup("SpellIcon")] public IconUi secondSpell, thirdSpell, tp, sprintIcon, autoAttackIcon, soulSpellIcon;

	[Header("Team Info")]
	[FoldoutGroup("TeamInfo")] public Image enemyRe, enemyWx, enemyLeng, teamRe, teamWx, teamLeng;
	[FoldoutGroup("TeamInfo")] public Color inViewBlueColor, inViewRedColor, outViewBlueColor, outViewRedColor, killedColor;

	[Header("Other Gameplay")]
	[FoldoutGroup("Other Gameplay")] public Camera mainCam;
	[FoldoutGroup("Other Gameplay")] public RectTransform radarRange;
	[FoldoutGroup("Other Gameplay")] public RectTransform nextAltarRadarIcon;
	[FoldoutGroup("Other Gameplay")] public RectTransform nextAltarRadarIconOnScreen;
	[FoldoutGroup("Other Gameplay")] public float pointerDistance = 8f;
	[FoldoutGroup("Other Gameplay")] public UIPingModule uIPingModule;
	[FoldoutGroup("Other Gameplay")] public Image tpFillImage;
	[FoldoutGroup("Other Gameplay")] public Image reviveFill;
	[FoldoutGroup("Other Gameplay")] public GameObject reviveUI;
    [FoldoutGroup("Other Gameplay")] public GameObject feedbackDeath;
    [FoldoutGroup("Cast")] public GameObject barCasting;
	[FoldoutGroup("Cast")] public Image canalisationImage;

	[Header("Ulti")]
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
		// <<
	}

	public void DisplaySoulSpell ()
	{
        waitingForPlayersPanel.SetActive(false);

        soulSpellSelector.gameObject.SetActive(true);
		soulSpellSelector.StartTimer();
        blurVolume.SetActive(true);

        gameUI.alpha = 0;
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
			SetLife(GameManager.Instance.networkPlayers[id].liveHealth, GetLifeImageOfTeamChamp(id));

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
		if (!GameManager.Instance.visiblePlayer.ContainsKey(GameManager.Instance.networkPlayers[id].transform))
		{
			return;
		}

		if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			SetLife(GameManager.Instance.networkPlayers[id].liveHealth, GetLifeImageOfTeamChamp(id));
		}
	}

	void OnPlayerGetHeal ( ushort id, ushort damage )
	{
		if (!GameManager.Instance.visiblePlayer.ContainsKey(GameManager.Instance.networkPlayers[id].transform))
		{
			return;
		}

		if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			SetLife(GameManager.Instance.networkPlayers[id].liveHealth, GetLifeImageOfTeamChamp(id));
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
			SetLife(0, GetLifeImageOfTeamChamp(idKilled));
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


		//actualse life team
		if (isVisible)
		{
			if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
			{
				SetLife(GameManager.Instance.networkPlayers[id].liveHealth, GetLifeImageOfTeamChamp(id));
			}
		}
	}

	internal void Revive ( bool state )
	{
		reviveUI.SetActive(state);
		reviveFill.fillAmount = 1;
	}

	void SetLife ( int numberLife, List<Image> imgs )
	{
		int i = 1;
		foreach (Image img in imgs)
		{
			if (i <= numberLife)
			{
				img.material = blueColor;
			}
			else
			{
				img.material = grayColor;
			}
			i++;
		}
	}

	List<Image> GetLifeImageOfTeamChamp ( ushort id )
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


		if (Input.GetKey(KeyCode.Tab))
		{
			cameraMinimap.Render();
		}
		if (Input.GetKeyUp(KeyCode.Tab))
		{
			minimapObj.SetActive(false);
		}


	}

	private void FixedUpdate ()
	{
		if (actualChar == null && GameFactory.GetLocalPlayerObj() != null)
		{
			actualChar = GameFactory.GetLocalPlayerObj().gameObject;
		}
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

	public void LinkInputName ( En_SpellInput _input, string _name )
	{
		switch (_input)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.SetupInputName(_name);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.SetupInputName(_name);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.SetupInputName(_name);
				break;

			case En_SpellInput.SoulSpell:
				soulSpellIcon.SetupInputName(_name);
				break;

		}
	}
	internal void SpecJoinGameScene ()
	{
		waitingForPlayersPanel.SetActive(false);
	}

	public void UpdateChargesUi ( int _charges, En_SpellInput _spellInput )
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
	
			case En_SpellInput.Click:
				autoAttackIcon.UpdatesChargesAmont(_charges);
				if (_charges > 0)
					autoAttackIcon.HideIcon(false);
				else
					autoAttackIcon.HideIcon(true);
				break;
			case En_SpellInput.SoulSpell:
				soulSpellIcon.UpdatesChargesAmont(_charges);
				if (_charges > 0)
					soulSpellIcon.HideIcon(false);
				else
					soulSpellIcon.HideIcon(true);
				break;

		}
	}

	public void CantCastFeedback ( En_SpellInput _spellInput )
	{

		AudioManager.Instance.Play2DAudio(AudioManager.Instance.cantCastSound, .3f);
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

	public void CooldownReady ( En_SpellInput _spellInput )
	{
		switch (_spellInput)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.CooldownReadyFeedback();
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.CooldownReadyFeedback();
				break;


			case En_SpellInput.Click:
				autoAttackIcon.CooldownReadyFeedback();
				break;

			case En_SpellInput.SoulSpell:
				soulSpellIcon.CooldownReadyFeedback();
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

	public void UpdateCanalisation ( float _percentageOfTheCanalisation, bool _isCasting = true )
	{
		if (_isCasting)
			canalisationImage.color = Color.red;
		else
			canalisationImage.color = Color.cyan;

		canalisationImage.fillAmount = _percentageOfTheCanalisation;
		if (_percentageOfTheCanalisation == 1)
			barCasting.SetActive(false);
		else
			barCasting.SetActive(true);
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

}
