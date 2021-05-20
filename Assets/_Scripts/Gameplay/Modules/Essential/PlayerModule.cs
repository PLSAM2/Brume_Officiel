using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;
using static GameData;
using System.Linq;
using DG.Tweening;
using UnityEngine.UI;
using UnityEngine.Events;

public class PlayerModule : MonoBehaviour
{
	[TabGroup("InputsPart")] public KeyCode firstSpellKey = KeyCode.A;
	[TabGroup("InputsPart")] public KeyCode secondSpellKey = KeyCode.E, crouching = KeyCode.LeftShift, cancelSpellKey = KeyCode.LeftControl, pingKey = KeyCode.G;
	[TabGroup("InputsPart")] public KeyCode soulSpellKey = KeyCode.F;
	[TabGroup("Modules")] public MovementModule movementPart;
	[TabGroup("Modules")] public SpellModule firstSpell, secondSpell, leftClick, pingModule;
	bool boolWasClicked = false;

	[TabGroup("SoulSpells")] public SpellModule decoyModule, thirdEyeModule, invisibilityModule, wardModule, speedUpModule, invulnerabilityModule;
	En_SoulSpell currentSoulModule;

	[TabGroup("GameplayInfos")] public Sc_CharacterParameters characterParameters;
	[TabGroup("GameplayInfos")] [ReadOnly] public Team teamIndex;
	[TabGroup("GameplayInfos")] public float revelationRangeWhileHidden = 10;
	[TabGroup("FeedbacksState")] [SerializeField] ParticleSystem powerUpParticle1, powerUpParticle2;
	[TabGroup("FeedbacksState")] public List<SkinnedMeshRenderer> skinnedRenderer = new List<SkinnedMeshRenderer>();
	Team otherTeam;
	[HideInInspector] public bool _isInBrume;
	En_CharacterState _state = En_CharacterState.Clear;
	public En_CharacterState state
	{
		get => _state | LiveEffectCharacterState();
		set { if (!mylocalPlayer.isOwner) { _state = value; } else return; }
	}
	[HideInInspector] public bool willListenInputs = true;
	En_CharacterState LiveEffectCharacterState ()
	{
		En_CharacterState _temp = En_CharacterState.Clear;

		if (allEffectLive.Count == 0)
			return En_CharacterState.Clear;
		foreach (EffectLifeTimed effectLive in allEffectLive)
		{
			_temp |= effectLive.effect.stateApplied;
		}

		return _temp;
	}
	[HideInInspector] public En_CharacterState oldState = En_CharacterState.Clear;
	[ReadOnly]
	public bool isInBrume
	{
		get => _isInBrume; set
		{
			_isInBrume = value;

			if (mylocalPlayer.isOwner)
			{
				GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", value);
				//	SetAltarSpeedBuffState(_isInBrume);
			}
		}
	}
	[TabGroup("Debugging")] [ReadOnly] public int brumeId;
	Vector3 lastRecordedPos;
	[TabGroup("Debugging")] [SerializeField] Color myColor;
	bool _isCrouched = false;
	bool isCrouched
	{ get => _isCrouched; set { _isCrouched = value; if (_isCrouched) { AddState(En_CharacterState.Crouched); } else { RemoveState(En_CharacterState.Crouched); } } }
	[TabGroup("Debugging")] public List<DamagesInfos> allHitTaken = new List<DamagesInfos>();
	private LayerMask brumeLayer;
	[TabGroup("GameplayInfos")] [SerializeField] SpriteRenderer mapIcon;
	[HideInInspector] public LocalPlayer mylocalPlayer;
	//interactibles
	[HideInInspector] public List<Interactible> interactiblesClose = new List<Interactible>();
	[TabGroup("GameplayInfos")] public Image menacedIcon;
	//effects
	[TabGroup("Debugging")] public List<EffectLifeTimed> allEffectLive;
	[TabGroup("Debugging")] public List<EffectLifeTimed> allTickLive;
	private ushort currentKeyIndex = 0;
	[Header("Altar Buff/Debuff")]
	[TabGroup("GameplayInfos")] [SerializeField] private Sc_Status enteringBrumeStatus;
	[TabGroup("GameplayInfos")] [SerializeField] private Sc_Status leavingBrumeStatus;
	private bool isAltarSpeedBuffActive = false;
	[HideInInspector] public bool cursedByShili = false;
	[Header("Cursed")]
	[TabGroup("GameplayInfos")] [SerializeField] public GameObject wxMark;
	[TabGroup("GameplayInfos")] [SerializeField] private Sc_Status wxMarkRef;
	[TabGroup("GameplayInfos")] [SerializeField] float shaderSpeedTransition = 10;
	[TabGroup("GameplayInfos")] float shaderTransitionValue = 1;
	[Header("AutoHeal")]
	[TabGroup("GameplayInfos")] public float timeWaitForHeal = 7.5f;
	[TabGroup("GameplayInfos")] float currentTimeTowait = 10;
	[TabGroup("GameplayInfos")] private float timerWaitForHeal = 0;
	[TabGroup("GameplayInfos")] private bool isWaitingForHeal = false;
	[TabGroup("GameplayInfos")] public float timeHealTick = 2.5f;
	[TabGroup("GameplayInfos")] public ushort healPerTick = 1;
	[TabGroup("GameplayInfos")] private float healTimer = 0;
	[TabGroup("GameplayInfos")] private bool isAutoHealing = false;
	[TabGroup("GameplayInfos")] public float timeInBrume;

	[HideInInspector] public int bonusHp;
	[HideInInspector] public Action<PlayerModule> OnMystEnter;
	[HideInInspector] public Action<PlayerModule> OnMystExit;
	[HideInInspector] public Action<PlayerModule> OnWalk;
	[HideInInspector] public bool tutorialListeningInput = false;
	//ALL ACTION 
	#region
	//[INPUTS ACTION]
	#region
	public Action<Vector3> DirectionInputedUpdate;
	//spell
	public Action<Vector3> firstSpellInput, secondSpellInput, thirdSpellInput, leftClickInput, soulSpellInput, pingInput;
	public Action<Vector3> firstSpellInputRealeased, secondSpellInputRealeased, thirdSpellInputRealeased, leftClickInputRealeased, soulSpellInputReleased, pingInputReleased;
	public Action startSneaking, stopSneaking;
	public Action<bool> rotationLock, cancelSpell;
	#endregion

	//[DASH ET MODIFICATEUR DE MOUVEMENT]
	#region
	public Action<ForcedMovement> forcedMovementAdded;
	public Action<bool> forcedMovementInterrupted;
	#endregion

	//pour l animator
	public Action<Vector3> onSendMovement;

	//[SPECIFIC ACTION NEEDED POUR LES SPELLS]
	#region
	public Action<float> reduceAllCooldown;
	public Action<float, En_SpellInput> reduceTargetCooldown;
	public Action upgradeKit, backToNormalKit;
	#endregion

	//pour la revelation hors de la brume
	public Action revelationCheck;

	//damagesInterruptionetc
	public Action hitCountered;
	//buffer input
	public Action spellResolved;
	[HideInInspector] public En_SpellInput spellInputedRecorded;
	public Action ultPointPickedUp;

	public Action OnStateChange;
	public Action<Sc_Spell> OnSpellTryCanalisation;
	[HideInInspector] public Sc_Spell currentSpellResolved;


	#endregion
	void Awake ()
	{
		mylocalPlayer = GetComponent<LocalPlayer>();
		GameManager.Instance.OnAllCharacterSpawned += Setup;
		GameManager.Instance.OnAllCharacterSpawned += mylocalPlayer.AllCharacterSpawn;
	}
	void Start ()
	{
		if (GameManager.Instance.gameStarted)
			Setup();

		if (mylocalPlayer.isOwner && !GameManager.Instance.haveChoiceSoulSpell)
		{
			GameManager.Instance.haveChoiceSoulSpell = true;

			GameManager.Instance.playerJoinedAndInit = true;
			GameManager.Instance.PlayerJoinedAndInitInScene(); // DIT AU SERVEUR QUE CE JOUEUR EST PRET A JOUER
		}
	}
	private void OnDestroy ()
	{

		GameManager.Instance.OnAllCharacterSpawned -= Setup;
		GameManager.Instance.OnAllCharacterSpawned -= mylocalPlayer.AllCharacterSpawn;
		if (mylocalPlayer.isOwner)
		{

			if (OnMystEnter != null)
				OnMystEnter -= TutorialManager.Instance.OnMystEnter;
			if (OnMystExit != null)
				OnMystExit -= TutorialManager.Instance.OnMystExit;
			if (OnWalk != null)
				OnWalk -= TutorialManager.Instance.OnWalk;

			rotationLock -= LockingRotation;
			reduceAllCooldown -= ReduceAllCooldowns;
			reduceTargetCooldown -= ReduceCooldown;
			spellResolved -= BuffInput;

		}
	}


	void OnGUI()
	{
        if (tutorialListeningInput == false)
        {
			return;
        }

		Event e = Event.current;

		if (Input.anyKeyDown && e.isKey && e.type == EventType.KeyDown)
		{
			TutorialManager.Instance.GetKeyPressed(e.keyCode);
		}

	}

	public virtual void Setup ()
	{
		if (firstSpell != null)
			firstSpell.SetupComponent(En_SpellInput.FirstSpell);
		if (secondSpell != null)
			secondSpell.SetupComponent(En_SpellInput.SecondSpell);
		if (leftClick != null)
			leftClick.SetupComponent(En_SpellInput.Click);
		if (pingModule != null)
			pingModule.SetupComponent(En_SpellInput.Ping);

		powerUpParticle1.gameObject.SetActive(false);
		powerUpParticle2.gameObject.SetActive(false);

		_state = En_CharacterState.Clear;
		oldState = state;


		if (teamIndex == Team.blue)
			otherTeam = Team.red;
		else
			otherTeam = Team.blue;

		lastRecordedPos = transform.position;
		StartCoroutine(WaitForVisionCheck());

		if (mylocalPlayer.isOwner)
		{
			UiManager.Instance.LinkInputName(En_SpellInput.Click, "LC");
			UiManager.Instance.LinkInputName(En_SpellInput.FirstSpell, "RC");
			UiManager.Instance.LinkInputName(En_SpellInput.SecondSpell, secondSpellKey.ToString());

			UiManager.Instance.LinkInputName(En_SpellInput.SoulSpell, soulSpellKey.ToString());
			spellResolved += BuffInput;
			//modulesPArt
			movementPart.SetupComponent(characterParameters.movementParameters);
			rotationLock += LockingRotation;

			reduceAllCooldown += ReduceAllCooldowns;
			reduceTargetCooldown += ReduceCooldown;

		}
		else
		{
			wardModule.SetupComponent(En_SpellInput.SoulSpell);
			if (NetworkManager.Instance.GetLocalPlayer().playerTeam == teamIndex)
			{
				foreach (SkinnedMeshRenderer skin in skinnedRenderer)
				{
					skin.material.SetFloat("_OutlinePower", 0);
				}
			}
			else
			{
				foreach (SkinnedMeshRenderer skin in skinnedRenderer)
				{
					skin.material.SetFloat("_OutlinePower", 10);
				}
			}
		}

		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(teamIndex))
			mapIcon.gameObject.SetActive(true);
		else
			mapIcon.gameObject.SetActive(false);

		ResetLayer();
	}

	public void GetDamageFx ()
	{
		StartCoroutine(DoEffectHit());
	}

	IEnumerator DoEffectHit ()
	{
		foreach (SkinnedMeshRenderer skin in skinnedRenderer)
		{
			LocalPlayer actualPlayer = GameFactory.GetActualPlayerFollow();

			if (actualPlayer == null) { break; }

			if (GameFactory.GetActualPlayerFollow().IsInMyTeam(teamIndex))
			{
				skin.material.DOFloat(1, "_HitRed", 0.1f);
			}
			else
			{
				skin.material.DOFloat(1, "_HitWhite", 0.1f);
			}
		}

		yield return new WaitForSeconds(0.1f);

		foreach (SkinnedMeshRenderer skin in skinnedRenderer)
		{
			LocalPlayer actualPlayer = GameFactory.GetActualPlayerFollow();

			if (actualPlayer == null) { break; }

			if (GameFactory.GetActualPlayerFollow().IsInMyTeam(teamIndex))
			{
				skin.material.DOFloat(0, "_HitRed", 0.4f);
			}
			else
			{
				skin.material.DOFloat(0, "_HitWhite", 0.4f);
			}
		}
	}

	public void InitSoulSpell ( En_SoulSpell _mySoulSpell )
	{
		currentSoulModule = _mySoulSpell;
		SelectionnedSoulSpellModule().SetupComponent(En_SpellInput.SoulSpell);
	}

	public void ResetLayer ()
	{
		if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
		{
			return;
		}

		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(teamIndex))
		{
			gameObject.layer = 7;
		}
		else
		{
			gameObject.layer = 8;
		}
	}

    public IEnumerator WaitForVisionCheck()
    {
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(.25f);
		CheckForBrumeRevelation();
		yield return new WaitForSeconds(.25f);
		CheckForBrumeRevelation();
		yield return new WaitForSeconds(characterParameters.delayBetweenDetection);
		StartCoroutine(WaitForVisionCheck());
    }

    void CheckForBrumeRevelation()
    {

        if (GameManager.Instance.currentLocalPlayer == null)
        {
            return;
        }

        if (ShouldBePinged())
        {
            //Debug.Log("I shouldBePinged");
            if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(teamIndex))
                LocalPoolManager.Instance.SpawnNewGenericInLocal(1, transform.position + Vector3.up * 0.1f, 90, 1);
            else
                LocalPoolManager.Instance.SpawnNewGenericInLocal(2, transform.position + Vector3.up * 0.1f, 90, 1);

        }
        lastRecordedPos = transform.position;
    }

    protected virtual void Update ()
	{

		TreatEffects();
		TreatTickEffects();

		if (oldState != state)
		{
			if ((state & En_CharacterState.Intengenbility) != 0)
				gameObject.layer = 16;
			else if ((oldState & En_CharacterState.Intengenbility) != 0)
				ResetLayer();

			if (oldState.HasFlag(En_CharacterState.Crouched) != state.HasFlag(En_CharacterState.Crouched))
			{
				mylocalPlayer.myAnimController.animator.SetBool("walk", state.HasFlag(En_CharacterState.Crouched));
			}

			if ((oldState & En_CharacterState.WxMarked) != 0 && (state & En_CharacterState.WxMarked) == 0)
			{
				mylocalPlayer.MarkThirdEye(false);
			}
			else if ((state & En_CharacterState.WxMarked) != 0 && (oldState & En_CharacterState.WxMarked) == 0)
			{
				print("i m marked" + name);
				mylocalPlayer.MarkThirdEye(true);
			}

			//PARTICLE FEEDBACK TOUSSA

			if ((oldState & En_CharacterState.PoweredUp) == 0 && (state & En_CharacterState.PoweredUp) != 0)
			{
				powerUpParticle1.gameObject.SetActive(true);
				powerUpParticle2.gameObject.SetActive(true);
			}
			else if ((oldState & En_CharacterState.PoweredUp) != 0 && (state & En_CharacterState.PoweredUp) == 0)
			{
				powerUpParticle1.gameObject.SetActive(false);
				powerUpParticle2.gameObject.SetActive(false);
			}

			if (mylocalPlayer.isOwner)
			{
				UiManager.Instance.StatusUpdate(state);
				mylocalPlayer.SendState(state);
			}

			OnStateChange?.Invoke();
		}
		oldState = state;

		if ((state & (En_CharacterState.Stunned | En_CharacterState.Slowed | En_CharacterState.Hidden)) != 0)
		{
			mylocalPlayer.myUiPlayerManager.HidePseudo(true);
		}
		else
			mylocalPlayer.myUiPlayerManager.HidePseudo(false);

		if (mylocalPlayer.isOwner && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
		{

			{
				//direction des fleches du clavier 
				DirectionInputedUpdate?.Invoke(directionInputed());
				//INPUT DETECTION SPELLS AND RUNNING
				#region
				if (Input.GetKeyDown(firstSpellKey))
					firstSpellInput?.Invoke(mousePos());
				else if (Input.GetKeyDown(secondSpellKey))
					secondSpellInput?.Invoke(mousePos());

				else if (Input.GetKeyDown(soulSpellKey))
					soulSpellInput?.Invoke(mousePos());
				else if (Input.GetKeyDown(cancelSpellKey))
					cancelSpell?.Invoke(false);
				else if (Input.GetKeyDown(pingKey))
					pingInput?.Invoke(mousePos());

				//AUTO
				else if (Input.GetAxis("Fire1") > 0 && !boolWasClicked)
				{
					leftClickInput?.Invoke(mousePos());
					boolWasClicked = true;
				}

				if (Input.GetKeyUp(firstSpellKey))
					firstSpellInputRealeased?.Invoke(mousePos());
				else if (Input.GetKeyUp(secondSpellKey))
					secondSpellInputRealeased?.Invoke(mousePos());

				else if (Input.GetKeyUp(soulSpellKey))
					soulSpellInputReleased?.Invoke(mousePos());
				else if (Input.GetKeyUp(pingKey))
					pingInputReleased?.Invoke(mousePos());
				else if (Input.GetAxis("Fire1") <= 0 && boolWasClicked)
				{
					leftClickInputRealeased?.Invoke(mousePos());
					boolWasClicked = false;
				}

				if (Input.GetKeyDown(crouching))
				{
					isCrouched = true;
					OnWalk?.Invoke(this);
				}
				else if (Input.GetKeyUp(crouching))
				{
					isCrouched = false;
				}
			}
			#endregion
			//MEGA TEMP
			mylocalPlayer.myUiPlayerManager.ShowStateIcon(state, 10, 10);

		}
		else
		{
			// TEMP
			mylocalPlayer.myUiPlayerManager.ShowStateIcon(state, 10, 10);
		}

		/*if (isAutoHealing)
		{
			CheckAutoHealProcess();
		}

		if (isWaitingForHeal)
		{
			WaitForHealProcess();
		}*/

	}
	protected virtual void FixedUpdate ()
	{


		if (mylocalPlayer.isOwner)
		{
			CheckBrumeShader();
		}
	}
	public void CheckBrumeShader ()
	{
		if (_isInBrume)
		{
			if (shaderTransitionValue > 0.99f)
			{
				return;
			}
			foreach (Material mat in GameManager.Instance.shaderDifMaterial)
			{
				shaderTransitionValue = Mathf.Lerp(shaderTransitionValue, 1, Time.deltaTime * shaderSpeedTransition);
				mat.SetFloat(GameManager.Instance.property, shaderTransitionValue);
			}

		}
		else
		{
			if (shaderTransitionValue < 0.01f)
			{
				return;
			}
			foreach (Material mat in GameManager.Instance.shaderDifMaterial)
			{
				shaderTransitionValue = Mathf.Lerp(shaderTransitionValue, 0, Time.deltaTime * shaderSpeedTransition);
				mat.SetFloat(GameManager.Instance.property, shaderTransitionValue);
			}
		}
	}
	
	public virtual void SetInBrumeStatut ( bool _value, int idBrume )
	{

		if (_value && !isInBrume)
		{
			OnMystEnter?.Invoke(this);

		}
		else if (!_value && isInBrume)
		{
			OnMystExit?.Invoke(this);

		}

		isInBrume = _value;
		brumeId = idBrume;

	}
	public void RetryInteractibleCapture ()
	{
		foreach (Interactible inter in interactiblesClose)
		{
			inter.CheckOnUnlock = true;
		}
	}

	public void ForceQuitAllInteractible ()
	{
		foreach (Interactible inter in interactiblesClose)
		{
			inter.ForceQuit();
		}
	}
	void ReduceCooldown ( float _duration, En_SpellInput _spell )
	{
		switch (_spell)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.ReduceCooldown(_duration);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.ReduceCooldown(_duration);
				break;

			case En_SpellInput.Click:
				leftClick.ReduceCooldown(_duration);
				break;

			case En_SpellInput.SoulSpell:
				SelectionnedSoulSpellModule().ReduceCooldown(_duration);
				break;
		}
	}
	void ReduceAllCooldowns ( float _duration )
	{
		firstSpell.ReduceCooldown(_duration);
		secondSpell.ReduceCooldown(_duration);
		leftClick.ReduceCooldown(_duration);
		SelectionnedSoulSpellModule().ReduceCooldown(_duration);
	}
	//vision
	#region

	bool ShouldBePinged ()
	{
		//le perso a pas bougé
		if ( Vector3.Distance(transform.position, lastRecordedPos) <= .2f || isInBrume)
			return false;

		//on choppe le player local
		PlayerModule _localPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

		//le perso est pas en train de crouched
		if (!_localPlayer.isInBrume || (state & En_CharacterState.Crouched) != 0 || (state & En_CharacterState.Hidden) != 0)
			return false;

		//DISTANCE > a la range
		/*if (Vector3.Distance(transform.position, _localPlayer.transform.position) >= _localPlayer.characterParameters.detectionRange)
			return false;*/

		return true;
	}

	#endregion
	//Vars 
	#region 
	public Vector3 directionInputed ()
	{
		return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
	}

	public Vector3 directionOfTheMouse ()
	{
		return Vector3.Normalize(mousePos() - transform.position);
	}

	public Vector3 mousePos ()
	{
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		RaycastHit hit;

		if (Physics.Raycast(ray, out hit, Mathf.Infinity, 1 << 10))
		{
			return new Vector3(hit.point.x, 0, hit.point.z);
		}
		else
		{
			return Vector3.zero;
		}
	}

	public Vector3 ClosestFreePos ( Vector3 _direction, float maxDistance )
	{
		RaycastHit _hit;
		if (Physics.Raycast(transform.position, _direction, out _hit, maxDistance, 1 << 9 | 1 << 19))
		{
			return _hit.point;
		}
		else
			return transform.position + _direction * maxDistance;
	}
	#endregion
	void LockingRotation ( bool _isLocked )
	{
		if (_isLocked)
			movementPart.rotLocked = true;
		else
			movementPart.rotLocked = false;
	}
	//STATUS GESTION
	#region
	void TreatEffects ()
	{
		List<EffectLifeTimed> _tempList = new List<EffectLifeTimed>();

		for (int i = 0; i < allEffectLive.Count; i++)
		{
			if (!allEffectLive[i].effect.isConstant)
				allEffectLive[i].liveLifeTime -= Time.deltaTime;

			if (allEffectLive[i].liveLifeTime <= 0)
			{
				_tempList.Add(allEffectLive[i]);
			}
		}

		foreach (EffectLifeTimed _effect in _tempList)
			allEffectLive.Remove(_effect);
	}

	void TreatTickEffects ()
	{
		List<EffectLifeTimed> _tempList = new List<EffectLifeTimed>();

		for (int i = 0; i < allTickLive.Count; i++)
		{
			allTickLive[i].liveLifeTime -= Time.deltaTime;
			allTickLive[i].lastTick += Time.deltaTime;

			if (allTickLive[i].liveLifeTime <= 0)
			{
				_tempList.Add(allTickLive[i]);
			}
		}

		foreach (EffectLifeTimed _effect in _tempList)
			allTickLive.Remove(_effect);
	}
	public void AddStatus ( Effect _statusToAdd )
	{
		Effect _tempTrad = new Effect();
		_tempTrad = _statusToAdd;
		EffectLifeTimed _newElement = new EffectLifeTimed();

		_newElement.liveLifeTime = _tempTrad.finalLifeTime;
		_newElement.baseLifeTime = _tempTrad.finalLifeTime;
		_newElement.effect = _tempTrad;

		if ((_statusToAdd.stateApplied & En_CharacterState.Silenced) != 0)
			cancelSpell?.Invoke(true);

		if (_statusToAdd.forcedKey != 0)
		{
			_newElement.key = _statusToAdd.forcedKey;
		}
		else
		{
			_newElement.key = currentKeyIndex;
			currentKeyIndex++;
		}

		if (_tempTrad.refreshOnApply)
		{
			EffectLifeTimed _temp = GetEffectByKey(_newElement.key);

			if (_temp != null)
			{
				_temp.Refresh();
				return;
			}
		}
		else
		{
			if (_tempTrad.doNotApplyIfExist)
			{
				EffectLifeTimed _temp = GetEffectByKey(_newElement.key);

				if (_temp != null)
				{
					return;
				}
			}
		}
		allEffectLive.Add(_newElement);

	}

	private EffectLifeTimed GetEffectByKey ( ushort key )
	{
		foreach (EffectLifeTimed effect in allEffectLive)
		{
			if (effect.key == key)
			{
				return effect;
			}
		}

		return null;
	}
	public bool StopStatus ( ushort key )
	{
		EffectLifeTimed _temp = allEffectLive.Where(x => x.key == key).FirstOrDefault();

		if (_temp != null)
		{
			allEffectLive.Remove(_temp);
			_temp.Stop();
			return true;
		}
		return false;
	}
	public void StopTickStatus ( ushort key )
	{
		EffectLifeTimed _temp = allTickLive.Where(x => x.key == key).FirstOrDefault();

		if (_temp != null)
		{
			_temp.Stop();
		}
	}
	public void AddState ( En_CharacterState _stateToadd )
	{
		_state |= _stateToadd;
	}

	public bool HasState ( En_CharacterState _stateToadd )
	{
		if (_state.HasFlag(_stateToadd))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	public void RemoveState ( En_CharacterState _stateToRemove )
	{
		_state &= ~_stateToRemove;
	}

	#endregion
	// Altars buff
	public void ApplySpeedBuffInServer ()
	{
		isAltarSpeedBuffActive = true;
		if (isInBrume)
		{
			mylocalPlayer.SendStatus(enteringBrumeStatus);
		}
	}

	public void SetAltarSpeedBuffState ( bool value ) // Call when entering brume
	{
		if (value)
		{
			StopStatus(enteringBrumeStatus.effect.forcedKey);
			StopStatus(leavingBrumeStatus.effect.forcedKey);
			mylocalPlayer.SendStatus(enteringBrumeStatus);
		}
		else
		{
			StopStatus(leavingBrumeStatus.effect.forcedKey);
			StopStatus(enteringBrumeStatus.effect.forcedKey);
			mylocalPlayer.SendStatus(leavingBrumeStatus);
		}
	}
	void PingMenace ()
	{
		menacedIcon.gameObject.SetActive(true);
	}
	void HideMenace ()
	{
		menacedIcon.gameObject.SetActive(false);
	}
	#region
	internal void ApplyWxMark ( ushort? dealerID = null )
	{
		/*if (GetEffectByKey(wxMarkRef.effect.forcedKey) == null)
			return;

		if (GetEffectByKey(wxMarkRef.effect.forcedKey).effect.hitBeforeProcOptionnalDamages > 0)
		{
			GetEffectByKey(wxMarkRef.effect.forcedKey).effect.hitBeforeProcOptionnalDamages--;
			return;
		}

		if (!StopStatus(wxMarkRef.effect.forcedKey))
			return;


		// wxMark.SetActive(false);
		DamagesInfos _tempDamages = new DamagesInfos();
		_tempDamages.damageHealth = wxMarkRef.effect.optionalDamagesInfos.damageHealth;

		//REMPLACER ICI LE DEALER PAR LE MEC QUI T APPLY LA MARQUE
		mylocalPlayer.DealDamages(_tempDamages, transform.position, dealerID, true);

		foreach (Sc_Status status in wxMarkRef.effect.optionalDamagesInfos.statusToApply) // already in DealDamage but we dont need to reaply state wx marked
		{
			mylocalPlayer.SendStatus(status);
		}
		mylocalPlayer.SendState(state);*/
	}
	void BuffInput ()
	{
		/*switch(spellInputedRecorded)
		{
			case En_SpellInput.Click:
				leftClick.StartCanalysing(mousePos());
				break;
			case En_SpellInput.FirstSpell:
				firstSpell.StartCanalysing(mousePos());
				break;
			case En_SpellInput.SecondSpell:
				secondSpell.StartCanalysing(mousePos());
				break;
			case En_SpellInput.ThirdSpell:
				thirdSpell.StartCanalysing(mousePos());
				break;
		}

		spellInputedRecorded = En_SpellInput.Null;*/
	}
	#endregion
	public void KillEveryStun ()
	{
		foreach (EffectLifeTimed _effect in allEffectLive)
		{
			if ((_effect.effect.stateApplied & En_CharacterState.Root) != 0 || (_effect.effect.stateApplied & En_CharacterState.Silenced) != 0)
			{
				_effect.liveLifeTime = 0;
			}
		}
	}
	public SpellModule ModuleLinkedToInput ( En_SpellInput _inputOfTheSpell )
	{
		switch (_inputOfTheSpell)
		{
			case En_SpellInput.FirstSpell:
				return firstSpell;

			case En_SpellInput.SecondSpell:
				return secondSpell;

			case En_SpellInput.Click:
				return leftClick;

			case En_SpellInput.SoulSpell:
				return SelectionnedSoulSpellModule();

		}

		return pingModule;
	}
	/*	public void SetAutoHealState ( bool state )
		{
			healTimer = timeHealTick;
			isAutoHealing = state;
		}
		public void WaitForHeal ( bool _isSeen )
		{

			SetAutoHealState(false);

			timerWaitForHeal = timeWaitForHeal;

			if (_isSeen)
			{
				healTimer = timeHealTick;

				mylocalPlayer.myUiPlayerManager.lifeBarWaitingForHeal.fillAmount = 0;

				//reset le point de vie qui etait en train de regen
				if (mylocalPlayer.liveHealth < characterParameters.maxHealthForRegen + bonusHp)
				{
					mylocalPlayer.myUiPlayerManager.allBarLife[Mathf.Clamp(mylocalPlayer.liveHealth, 0, characterParameters.maxHealthForRegen + bonusHp)].SetFillAmount(0);
				}

			}
			isWaitingForHeal = !_isSeen;
		}*/

	SpellModule SelectionnedSoulSpellModule ()
	{
		switch (currentSoulModule)
		{
			case En_SoulSpell.Ward:
				return wardModule;
			case En_SoulSpell.Invisible:
				return invisibilityModule;
			case En_SoulSpell.ThirdEye:
				return thirdEyeModule;
			case En_SoulSpell.SpeedUp:
				return speedUpModule;
			case En_SoulSpell.Decoy:
				return decoyModule;
		}
		return wardModule;
	}


	public void EventTutorial(MystEvent mystEvent)
	{
        switch (mystEvent)
        {
            case MystEvent.Entered:
				OnMystEnter += TutorialManager.Instance.OnMystEnter;
				break;
            case MystEvent.Exit:
				OnMystExit += TutorialManager.Instance.OnMystExit;
				break;
            default:
				throw new Exception("not existing event");
		}
    }


	public void EventTutorial(MovementEvent movementEvent)
	{
		switch (movementEvent)
		{
			case MovementEvent.Walk:
				OnWalk += TutorialManager.Instance.OnWalk;
				break;
			default:
				throw new Exception("not existing event");
		}
	}

}

[System.Flags]
public enum En_CharacterState
{
	Clear = 1 << 0,
	Slowed = 1 << 1,
	SpedUp = 1 << 2,
	Root = 1 << 3,
	Canalysing = 1 << 4,
	Silenced = 1 << 5,
	Crouched = 1 << 6,
	Embourbed = 1 << 7,
	WxMarked = 1 << 8,
	Hidden = 1 << 9,
	Invulnerability = 1 << 10,
	Intengenbility = 1 << 11,
	PoweredUp = 1 << 12,
	ForcedMovement = 1 << 13,
	StopInterpolate = 1 << 14,

	Stunned = Silenced | Root,
}

[System.Serializable]
public class DamagesInfos
{
	public DamagesInfos () { }
	public DamagesInfos ( ushort damageHealth )
	{
		this.damageHealth = damageHealth;
	}

	[HideInInspector] public string playerName;

	[TabGroup("NormalDamages")] public ushort damageHealth;
	[TabGroup("NormalDamages")] public Sc_Status[] statusToApply;
	[TabGroup("NormalDamages")] public Sc_ForcedMovement movementToApply = null;

	/*[TabGroup("EffectIfConditionCompleted")] public En_CharacterState stateNeeded = En_CharacterState.Embourbed;
	[TabGroup("EffectIfConditionCompleted")] public ushort additionalDamages;
	[TabGroup("EffectIfConditionCompleted")] public Sc_Status[] additionalStatusToApply;
	[TabGroup("EffectIfConditionCompleted")] public Sc_ForcedMovement additionalMovementToApply = null;*/

	[HideInInspector]
	public bool isUsable => statusToApply.Length > 0 || damageHealth > 0 || movementToApply != null;
}

[System.Serializable]
public class Effect
{
	[HorizontalGroup("Group1")] public bool canBeForcedStop = false;
	[HorizontalGroup("Group1")] [ShowIf("canBeForcedStop")] public ushort forcedKey = 0;
	[HorizontalGroup("Group2")] [HideIf("isConstant")] public float finalLifeTime;
	[HorizontalGroup("Group2")] public bool isConstant = false;
	[HorizontalGroup("Group3")] public bool refreshOnApply = false;
	[HorizontalGroup("Group3")] [HideIf("refreshOnApply")] public bool doNotApplyIfExist = false;

	public En_CharacterState stateApplied;
	public bool isHardControl => ((stateApplied & En_CharacterState.Root) != 0 || (stateApplied & En_CharacterState.Silenced) != 0);

	bool isMovementOriented => ((stateApplied & En_CharacterState.Slowed) != 0 || (stateApplied & En_CharacterState.SpedUp) != 0);
	[Range(0, 1)] [ShowIf("isMovementOriented")] public float percentageOfTheMovementModifier = 1;
	[ShowIf("isMovementOriented")] public AnimationCurve decayOfTheModifier = AnimationCurve.Constant(1, 1, 1);
	public Effect () { }
}

[System.Serializable]
public class EffectLifeTimed
{
	public ushort key = 0;

	public Effect effect;
	public float liveLifeTime;
	public float baseLifeTime;

	[HideInInspector] public float lastTick = 0;
	public void Stop ()
	{
		liveLifeTime = 0;
	}

	internal void Refresh ()
	{
		liveLifeTime = effect.finalLifeTime;
	}
}