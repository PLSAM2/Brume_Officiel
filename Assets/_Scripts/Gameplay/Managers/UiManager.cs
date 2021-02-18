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
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI allyScore;
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI ennemyScore;
	[FoldoutGroup("GlobalUi")] public UIAltarList uiAltarList;
	[FoldoutGroup("GlobalUi")] public GameObject echapMenu;
	[FoldoutGroup("GlobalUi")] public GameObject victoryPanel;
	[FoldoutGroup("GlobalUi")] public GameObject loosePanel;
	[FoldoutGroup("GlobalUi")] public EndGameScore endGameScore;
	[FoldoutGroup("GlobalUi")] public GameObject toDisableInEndGame;
	[FoldoutGroup("GlobalUi")] public ChatControl chat;

	[FoldoutGroup("Minimap")] public Camera cameraMinimap;
	[FoldoutGroup("Minimap")] private bool waitForMinimapUpdate = false;


	[FoldoutGroup("GeneralMessage")] [SerializeField] private Text generalMessage;
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
	[FoldoutGroup("SpellIcon")] public IconUi secondSpell, thirdSpell, tp, sprintIcon, autoAttackIcon, wardIcon;

	[Header("Team Info")]
	[FoldoutGroup("TeamInfo")] public Image enemyRe, enemyWx, enemyLeng, teamRe, teamWx, teamLeng;
	[FoldoutGroup("TeamInfo")] public Color inViewBlueColor, inViewRedColor, outViewBlueColor, outViewRedColor, killedColor;
	[FoldoutGroup("TeamInfo")] public Image lifeYang, lifeShili, lifeYin;
	[FoldoutGroup("TeamInfo")] public List<AllyIconUI> allyIconUIs = new List<AllyIconUI>();

	[Header("Other Gameplay")]
	[FoldoutGroup("Other Gameplay")] public Camera mainCam;
	[FoldoutGroup("Other Gameplay")] public RectTransform radarRange;
	[FoldoutGroup("Other Gameplay")] public RectTransform nextAltarRadarIcon;
	[FoldoutGroup("Other Gameplay")] public RectTransform nextAltarRadarIconOnScreen;
	[FoldoutGroup("Other Gameplay")] public float pointerDistance = 8f;
	[FoldoutGroup("Other Gameplay")] public Image hitFeedback;
	[FoldoutGroup("Other Gameplay")] public UIPingModule uIPingModule;
	[FoldoutGroup("Other Gameplay")] public Image tpFillImage;
	[FoldoutGroup("Cast")] public GameObject barCasting;
	[FoldoutGroup("Cast")] public Image canalisationImage;

    [Header("Ulti")]
    [FoldoutGroup("Ulti")] public UltiBar parentUltiWX, parentUltiRE, parentUltiLENG;
    [FoldoutGroup("Ulti")] public GameObject prefabUltiPoint;

    public Transform parentWaypoint;

	private GameObject actualChar;
	private GameObject actualUnlockedAltar = null;
	private float radarRangeXDistanceFromZero = 0;
	private float radarRangeYDistanceFromZero = 0;
	private int altarCaptured = 0;

	[Header("Spec Mode")]
	[FoldoutGroup("SpecMode")] public SpecMode specMode;

	[Header("Misc")]
	[FoldoutGroup("Misc")] public GameObject DebuggerPanel;


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

		lifeShili.fillAmount = 0;
		lifeYang.fillAmount = 0;
		lifeYin.fillAmount = 0;
	}

	private void OnEnable ()
	{
		GameManager.Instance.OnPlayerDie += OnPlayerDie;
		GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;
		GameManager.Instance.OnPlayerGetDamage += OnPlayerTakeDamage;
		GameManager.Instance.OnPlayerSpawn += OnPlayerSpawn;
	}

	private void OnDisable ()
	{
		GameManager.Instance.OnPlayerDie -= OnPlayerDie;
		GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
		GameManager.Instance.OnPlayerGetDamage -= OnPlayerTakeDamage;
		GameManager.Instance.OnPlayerSpawn -= OnPlayerSpawn;
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
			GetLifeImageOfTeamChamp(id).fillAmount = 1;

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

	void OnPlayerTakeDamage ( ushort id, ushort damage )
	{
        if (!GameManager.Instance.visiblePlayer.ContainsKey(GameManager.Instance.networkPlayers[id].transform))
        {
            return;
        }

        if (RoomManager.Instance.actualRoom.playerList[id].playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			GetLifeImageOfTeamChamp(id).fillAmount = (float)GameManager.Instance.networkPlayers[id].liveHealth
				/ GameFactory.GetMaxLifeOfPlayer(id);
		}
	}

	void OnPlayerDie ( ushort idKilled, ushort idKiller )
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
                GetLifeImageOfTeamChamp(id).fillAmount = (float)GameManager.Instance.networkPlayers[id].liveHealth
                    / GameFactory.GetMaxLifeOfPlayer(id);
            }
        }
    }

	Image GetLifeImageOfTeamChamp ( ushort id )
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
			SetEchapMenuState();
		}
		if (Input.GetKeyDown(KeyCode.Return))
		{
			chat.Focus();
		}

		if (Input.GetKey(KeyCode.LeftControl) && Input.GetKeyDown(KeyCode.F2))
		{
			DebuggerPanel.SetActive(!DebuggerPanel.activeInHierarchy);
		}
	}

	private void FixedUpdate ()
	{
		if (actualChar == null && GameFactory.GetLocalPlayerObj() != null)
		{
			actualChar = GameFactory.GetLocalPlayerObj().gameObject;
		}

		if (!waitForMinimapUpdate)
		{
			StartCoroutine(MinimapUpdate());
		}

		if (generalMessageList.Count > 0 && !waitForGenMessageAnimEnd)
		{
			StartCoroutine(GeneralMessage());
		}


	}

	internal void SetUltimateStacks ( ushort playerId, ushort v )
	{
		int index = 1;
		switch (RoomManager.Instance.actualRoom.playerList[playerId].playerCharacter)
		{
			case Character.none:
				throw new Exception("none character");
			case Character.WuXin:
				index = 0;
				break;
			case Character.Re:
				index = 1;
				break;
			case Character.Leng:
				index = 2;
				break;
			case Character.test:
				throw new Exception("test character");
			default:
				throw new Exception("DEFAULT");
		}

		allyIconUIs[index].SetUltimateProgress(v);
	}

	internal void UnlockNewAltar ( Altar altar )
	{
		actualUnlockedAltar = altar.gameObject;
		nextAltarRadarIcon.gameObject.SetActive(true);
	}

	internal void NewAltarCaptured ( Team capturingTeam )
	{
		uiAltarList.DisplayImage(altarCaptured, capturingTeam);
		altarCaptured++;
	}

	IEnumerator MinimapUpdate ()
	{
		waitForMinimapUpdate = true;
		yield return new WaitForSeconds(0.1f);
		//cameraMinimap.Render();
		waitForMinimapUpdate = false;
	}

	public void SetEchapMenuState ()
	{
		echapMenu.SetActive(!echapMenu.activeInHierarchy);
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

			case En_SpellInput.ThirdSpell:
				thirdSpell.UpdateCooldown(_timeRemaining, _completeCd);
				break;

			case En_SpellInput.Maj:
				sprintIcon.UpdateCooldown(_timeRemaining, _completeCd);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.UpdateCooldown(_timeRemaining, _completeCd);
				break;
			case En_SpellInput.Ward:
				wardIcon.UpdateCooldown(_timeRemaining, _completeCd);
				break;
			case En_SpellInput.TP:
				tp.UpdateCooldown(_timeRemaining, _completeCd);
				break;
		}
	}

	public void UpdateDescription(En_SpellInput _spell, string _name, string _cooldownText, string _description)
	{
		switch (_spell)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.SetupTooltip(_name, _cooldownText, _description);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.SetupTooltip(_name, _cooldownText, _description);
				break;

			case En_SpellInput.ThirdSpell:
				thirdSpell.SetupTooltip(_name, _cooldownText, _description);
				break;

			case En_SpellInput.Maj:
				sprintIcon.SetupTooltip(_name, _cooldownText, _description);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.SetupTooltip(_name, _cooldownText, _description);
				break;

			case En_SpellInput.Ward:
				wardIcon.SetupTooltip(_name, _cooldownText, _description);
				break;

			case En_SpellInput.TP:
				tp.SetupTooltip(_name, _cooldownText, _description);
				break;
		}
	}

	public void SetupIcon ( Sc_Spell _spellAttached, En_SpellInput _input )
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

			case En_SpellInput.TP:
				tp.SetSprite(_spellAttached.spellIcon);
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
			case En_SpellInput.TP:
				tp.SetupInputName(_name);
				break;
		}
	}

	internal void AllPlayerJoinGameScene ()
	{
		foreach (KeyValuePair < ushort,ushort> pstacks in RoomManager.Instance.ultimateStack)
        {
			SetUltimateStacks(pstacks.Key, pstacks.Value);
        }

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

	public void CantCastFeedback ( En_SpellInput _spellInput )
	{

		AudioManager.Instance.Play2DAudio(AudioManager.Instance.cantCastSound,.3f);
		switch (_spellInput)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.CantCastFeedback();
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.CantCastFeedback();
				break;

			case En_SpellInput.ThirdSpell:
				thirdSpell.CantCastFeedback();
				break;

			case En_SpellInput.Click:
				autoAttackIcon.CantCastFeedback();
				break;

			case En_SpellInput.TP:
				tp.CantCastFeedback();
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

			case En_SpellInput.ThirdSpell:
				thirdSpell.CooldownReadyFeedback();
				break;

			case En_SpellInput.Click:
				autoAttackIcon.CooldownReadyFeedback();
				break;

			case En_SpellInput.TP:
				tp.CooldownReadyFeedback();
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

	public void UpdateCanalisation(float _percentageOfTheCanalisation, bool _isCasting =true)
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

	public void SetAlphaBrume ( float value )
	{
		brumeFilter.color = new Color(brumeFilter.color.r, brumeFilter.color.g, brumeFilter.color.b, value);
	}

	public void DisplayGeneralMessage ( string value )
	{
		generalMessageList.Add(value);
	}

	IEnumerator GeneralMessage ()
	{
		waitForGenMessageAnimEnd = true;
		generalMessage.DOText(generalMessageList[0], 0.7f, false, ScrambleMode.Uppercase);
		generalMessageAnim.Play("GenMessage");

		yield return new WaitForSeconds(generalMessageAnimTime);
		generalMessage.text = "";
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
	public void EndGamePanel ( bool victory = false, ushort newPoints = 0, Team team = Team.none )
	{
		victoryPanel.SetActive(victory);
		loosePanel.SetActive(!victory);
		endGameScore.gameObject.SetActive(true);
		endGameScore.EndGame(newPoints, team);

		toDisableInEndGame.SetActive(false);
	}
	public void FeedbackHit ()
	{
		if (hitFeedback == null)
		{
			return;
		}

		hitFeedback.DOKill();
		hitFeedback.color = new Color(hitFeedback.color.r, hitFeedback.color.g, hitFeedback.color.b, 1);
		int randomXSize = UnityEngine.Random.Range(-100, 100);
		int randomYSize = UnityEngine.Random.Range(-100, 100);

		if (randomXSize > 0)
			hitFeedback.rectTransform.localScale = new Vector2(1, hitFeedback.rectTransform.localScale.y);
		else
			hitFeedback.rectTransform.localScale = new Vector2(-1, hitFeedback.rectTransform.localScale.y);

		if (randomYSize > 0)
			hitFeedback.rectTransform.localScale = new Vector2(hitFeedback.rectTransform.localScale.x, 1);
		else
			hitFeedback.rectTransform.localScale = new Vector2(hitFeedback.rectTransform.localScale.x, -1);

		hitFeedback.DOColor(new Color(hitFeedback.color.r, hitFeedback.color.g, hitFeedback.color.b, 0), 1.2f);
	}

}
