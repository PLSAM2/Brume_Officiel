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
	[FoldoutGroup("GlobalUi")] public TextMeshProUGUI endZoneTimer;
	[FoldoutGroup("GlobalUi")] public Image endZoneBarTimer;
	[FoldoutGroup("GlobalUi")] public Animator endZoneAnim;
	[FoldoutGroup("GlobalUi")] public GameObject endZoneTimerObj;
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
    [FoldoutGroup("Ulti")] public FeedBackGainUlti feedBackUlti;
    [FoldoutGroup("Ulti")] public GameObject prefabLifeBar;
    [FoldoutGroup("Ulti")] public Material blueColor, grayColor;
    [FoldoutGroup("Ulti")] public Transform parentLifeWX, parentLifeRE, parentLifeLENG;
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

        parentUltiWX.isOwner = NetworkManager.Instance.GetLocalPlayer().playerCharacter == Character.WuXin;
        parentUltiRE.isOwner = NetworkManager.Instance.GetLocalPlayer().playerCharacter == Character.Re;
        parentUltiLENG.isOwner = NetworkManager.Instance.GetLocalPlayer().playerCharacter == Character.Leng;
    }

    void SpawnLifeBar(Transform parent, List<Image> listImg, Character champ)
    {
        for (int i = 0; i < GameFactory.GetMaxLifeOfPlayer(champ); i++)
        {
            Image img = Instantiate(prefabLifeBar, parent).GetComponent<Image>();
            img.material = grayColor;
            listImg.Add(img);
        }
    }

    private void OnEnable ()
	{
		GameManager.Instance.OnPlayerDie += OnPlayerDie;
		GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;
		GameManager.Instance.OnPlayerGetDamage += OnPlayerTakeDamage;
		GameManager.Instance.OnPlayerSpawn += OnPlayerSpawn;
        GameManager.Instance.OnPlayerUltiChange += OnPlayerUltiChange;
	}

	private void OnDisable ()
	{
		GameManager.Instance.OnPlayerDie -= OnPlayerDie;
		GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
		GameManager.Instance.OnPlayerGetDamage -= OnPlayerTakeDamage;
		GameManager.Instance.OnPlayerSpawn -= OnPlayerSpawn;
        GameManager.Instance.OnPlayerUltiChange -= OnPlayerUltiChange;
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

	void OnPlayerTakeDamage ( ushort id, ushort damage )
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
		//
		if (idKilled == idKiller)
		{
			DisplayGeneralMessage("You slain an ennemy");
			//play son kill

		}


		//UI Minimap info
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

    void SetLife(int numberLife, List<Image> imgs)
    {
        int i = 1;
        foreach(Image img in imgs)
        {
            if(i <= numberLife)
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
                chat.Send();
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

	internal void UnlockNewAltar ( Altar altar )
	{
		actualUnlockedAltar = altar.gameObject;
		nextAltarRadarIcon.gameObject.SetActive(true);
	}

    List<Altar> altarCapture = new List<Altar>();
	public void OnAltarUnlock (Altar _altar, Team _capturingTeam )
	{
        if (altarCapture.Contains(_altar))
        {
            return;
        }

        altarCapture.Add(_altar);
        uiAltarList.GainTeam(_capturingTeam);
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

	public void SetupIcon(En_SpellInput _spell,Sc_Spell _spellToTooltip)
	{
		switch (_spell)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.SetupIcon(_spell,_spellToTooltip);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.SetupIcon(_spell,_spellToTooltip);
				break;

			case En_SpellInput.ThirdSpell:
				thirdSpell.SetupIcon(_spell,_spellToTooltip);
				break;

			case En_SpellInput.Maj:
				sprintIcon.SetupIcon(_spell,_spellToTooltip);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.SetupIcon(_spell,_spellToTooltip);
				break;

			case En_SpellInput.Ward:
				wardIcon.SetupIcon(_spell,_spellToTooltip);
				break;

			case En_SpellInput.TP:
				tp.SetupIcon(_spell,_spellToTooltip);
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
		waitingForPlayersPanel.SetActive(false);

        //InitUlti
        ushort? wxId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, Character.WuXin);
        //print(RoomManager.Instance.GetPlayerData((ushort)wxId).ultStacks);
        parentUltiWX.Init(GameData.characterUltMax[Character.WuXin], wxId != null ? RoomManager.Instance.GetPlayerData((ushort) wxId).ultStacks : (ushort) 0);

        ushort? reId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, Character.Re);
        parentUltiRE.Init(GameData.characterUltMax[Character.Re], reId != null ? RoomManager.Instance.GetPlayerData((ushort) reId).ultStacks : (ushort) 0);

        ushort? lengId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, Character.Leng);
        parentUltiLENG.Init(GameData.characterUltMax[Character.Leng], lengId != null ? RoomManager.Instance.GetPlayerData((ushort)lengId).ultStacks : (ushort)0);
    }

    void OnPlayerUltiChange(ushort _player, ushort _number)
    {
        switch (RoomManager.Instance.actualRoom.playerList[_player].playerCharacter)
        {
            case Character.WuXin:
                parentUltiWX.SetValue(_number);
                break;
            case Character.Re:
                parentUltiRE.SetValue(_number);
                break;
            case Character.Leng:
                parentUltiLENG.SetValue(_number);
                break;
        }
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
