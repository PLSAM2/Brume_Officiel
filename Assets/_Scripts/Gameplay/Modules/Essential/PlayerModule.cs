using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;
using static GameData;
using System.Linq;

public class PlayerModule : MonoBehaviour
{
	[Header("Inputs")]
	public KeyCode firstSpellKey = KeyCode.A;
	public KeyCode secondSpellKey = KeyCode.E, thirdSpellKey = KeyCode.R, freeCamera = KeyCode.Space, crouching = KeyCode.LeftShift;
	public KeyCode interactKey = KeyCode.F;
	public KeyCode wardKey = KeyCode.Alpha4;
	private LayerMask groundLayer;
	bool boolWasClicked = false;
	[Header("GameplayInfos")]
	public Sc_CharacterParameters characterParameters;
	[ReadOnly] public Team teamIndex;
	[HideInInspector] public bool _isInBrume;
	[ShowInInspector] En_CharacterState _state = En_CharacterState.Clear;
	[ReadOnly]
	public En_CharacterState state
	{
		get => _state | LiveEffectCharacterState();
		set { if (!mylocalPlayer.isOwner) { _state = value; } else return; }
	}

	En_CharacterState LiveEffectCharacterState ()
	{
		En_CharacterState _temp = En_CharacterState.Clear;

		if (allEffectLive.Count ==0)
			return  En_CharacterState.Clear;
		foreach (EffectLifeTimed effectLive in allEffectLive)
		{
			_temp |= effectLive.effect.stateApplied;
		}

		return _temp;
	}

	En_CharacterState _oldState = En_CharacterState.Clear;

    [ReadOnly]
	public bool isInBrume
	{
		get => _isInBrume; set
		{
			_isInBrume = value;

			if(mylocalPlayer.isOwner)
				GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", value);

			if (isAltarSpeedBuffActive)
			{
				print("Iexitbrume");
				SetAltarSpeedBuffState(_isInBrume);
			}
		}
	}
	[ReadOnly] public int brumeId;
	Vector3 lastRecordedPos;

    //ghost
    public bool isInGhost = false;
    public bool isInBrumeBeforeGhost = false;
    public int brumeIdBeforeGhost;

    [Header("DamagesPart")]
	bool _isCrouched = false;
	bool isCrouched

	{ get => _isCrouched; set { _isCrouched = value; if (_isCrouched) { AddState(En_CharacterState.Crouched); } else { RemoveState(En_CharacterState.Crouched); } } }
	[HideInInspector] public List<DamagesInfos> allHitTaken = new List<DamagesInfos>();

	[Header("Vision")]
	public GameObject sonar;
	public LayerMask brumeLayer;
	[SerializeField] SpriteRenderer mapIcon;

	[Header("CharacterBuilder")]
	public MovementModule movementPart;
	[SerializeField] SpellModule firstSpell, secondSpell, thirdSpell, leftClick, ward;
	[HideInInspector] public LocalPlayer mylocalPlayer;

	//interactibles
	[HideInInspector] public List<Interactible> interactiblesClose = new List<Interactible>();
	[HideInInspector] public List<PlayerSoul> playerSouls = new List<PlayerSoul>();

	//effects
	public List<EffectLifeTimed> allEffectLive;
	public List<EffectLifeTimed> allTickLive;
	private ushort currentKeyIndex = 0;

	[Header("Altar Buff/Debuff")]
	[SerializeField] private Sc_Status enteringBrumeStatus;
	[SerializeField] private Sc_Status leavingBrumeStatus;
	private bool isAltarSpeedBuffActive = false;
	public Sc_Status poisonousEffect;
	public bool isPoisonousEffectActive = false;

	[Header("Cursed")]
	public bool cursedByShili = false;
	[SerializeField] protected GameObject wxMark;
	[SerializeField] private Sc_Status wxMarkRef;
	//ALL ACTION 
	#region
	//[INPUTS ACTION]
	#region
	public Action<Vector3> DirectionInputedUpdate;
	//spell
	public Action<Vector3> firstSpellInput, secondSpellInput, thirdSpellInput, leftClickInput, wardInput;
	public Action<Vector3> firstSpellInputRealeased, secondSpellInputRealeased, thirdSpellInputRealeased, leftClickInputRealeased, wardInputReleased;
	public Action startSneaking, stopSneaking;
	public Action<bool> rotationLock;
	#endregion

	//[DASH ET MODIFICATEUR DE MOUVEMENT]
	#region
	public Action<ForcedMovement> forcedMovementAdded;
	public Action forcedMovementInterrupted;
	#endregion

	//pour l animator
	public Action<Vector3> onSendMovement;

	//[SPECIFIC ACTION NEEDED POUR LES SPELLS]
	#region
	public static Action<float> reduceAllCooldown;
	public static Action<float, En_SpellInput> reduceTargetCooldown;
	public Action upgradeKit, backToNormalKit;
	#endregion

	//pour la revelation hors de la brume
	public Action revelationCheck;

	#endregion

	void Awake ()
	{
		mylocalPlayer = GetComponent<LocalPlayer>();

		GameManager.Instance.AllCharacterSpawned += Setup;
	}

	void Start ()
	{
		if (GameManager.Instance.gameStarted)
			Setup();

		if (mylocalPlayer.isOwner)
		{
			GameManager.Instance.PlayerJoinedAndInitInScene(); // DIT AU SERVEUR QUE CE JOUEUR EST PRET A JOUER
		}
		//	oldPos = transform.position;
	}

	private void OnDestroy ()
	{
		GameManager.Instance.AllCharacterSpawned -= Setup;

		if (!mylocalPlayer.isOwner)
		{

		}
		else
		{
			rotationLock -= LockingRotation;
			reduceAllCooldown -= ReduceAllCooldowns;
			reduceTargetCooldown -= ReduceCooldown;
		}
	}
	void Setup ()
	{
		firstSpell?.SetupComponent(En_SpellInput.FirstSpell);
		secondSpell?.SetupComponent(En_SpellInput.SecondSpell);
		thirdSpell?.SetupComponent(En_SpellInput.ThirdSpell);
		leftClick?.SetupComponent(En_SpellInput.Click);
		ward?.SetupComponent(En_SpellInput.Ward);

	
		_state = En_CharacterState.Clear;

		if (mylocalPlayer.isOwner)
		{

			UiManager.Instance.LinkInputName(En_SpellInput.Click, "LC");
			UiManager.Instance.LinkInputName(En_SpellInput.FirstSpell, firstSpellKey.ToString());
			UiManager.Instance.LinkInputName(En_SpellInput.SecondSpell, secondSpellKey.ToString());
			UiManager.Instance.LinkInputName(En_SpellInput.ThirdSpell, thirdSpellKey.ToString());
			UiManager.Instance.LinkInputName(En_SpellInput.Ward, wardKey.ToString());

			mapIcon.color = Color.blue;

			//modulesPArt
			movementPart.SetupComponent(characterParameters.movementParameters);
			rotationLock += LockingRotation;
			reduceAllCooldown += ReduceAllCooldowns;
			reduceTargetCooldown += ReduceCooldown;
		}
		else
		{
			if (teamIndex == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
				mapIcon.color = Color.green;
			else
				mapIcon.color = Color.red;

			StartCoroutine(WaitForVisionCheck());
		}
	}

	void Update ()
	{
		if (mylocalPlayer.isOwner)
		{
						//direction des fleches du clavier 
			DirectionInputedUpdate?.Invoke(directionInputed());

			//INPUT DETECTION SPELLS AND RUNNING
			#region
			if (Input.GetKeyDown(firstSpellKey))
				firstSpellInput?.Invoke(mousePos());
			else if (Input.GetKeyDown(secondSpellKey))
				secondSpellInput?.Invoke(mousePos());
			else if (Input.GetKeyDown(thirdSpellKey))
				thirdSpellInput?.Invoke(mousePos());
			else if (Input.GetKeyDown(wardKey))
				wardInput?.Invoke(mousePos());
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
			else if (Input.GetKeyUp(thirdSpellKey))
				thirdSpellInputRealeased?.Invoke(mousePos());
			else if (Input.GetKeyUp(wardKey))
				wardInputReleased?.Invoke(mousePos());
			else if (Input.GetAxis("Fire1") <= 0 && boolWasClicked)
			{
				leftClickInputRealeased?.Invoke(mousePos());
				boolWasClicked = false;
			}

			if (Input.GetKeyDown(interactKey))
			{
				foreach (Interactible interactible in interactiblesClose)
				{
					if (interactible == null)
						return;
					LockingRotation(true);
					interactible.TryCapture(teamIndex, this);
				}
			}
			else if (Input.GetKeyUp(interactKey))
			{
				foreach (Interactible interactible in interactiblesClose)
				{
					if (interactible == null)
						return;
					LockingRotation(false);
					interactible.StopCapturing(teamIndex);
				}
			}

			if (Input.GetKeyDown(crouching))
			{
				isCrouched = true;
			}


			else if (Input.GetKeyUp(crouching))
			{
				isCrouched = false;
			}

				#endregion

				//camera
				if (Input.GetKeyUp(freeCamera))
				CameraManager.Instance.LockCamera?.Invoke();
			else if (Input.GetKey(freeCamera))
				CameraManager.Instance.UpdateCameraPos?.Invoke();
		}
		else
			return;
	}

	private void FixedUpdate ()
	{
		TreatEffects();
		TreatTickEffects();
		if (!mylocalPlayer.isOwner)
			return;
		else
		{
			if (_oldState != state)
			{
				UiManager.Instance.StatusUpdate(state);
				mylocalPlayer.SendState(state);
				StateChanged(state);
				_oldState = state;
			}
		}
	}


	protected virtual void StateChanged(En_CharacterState state)
    {

    }

	public virtual void SetInBrumeStatut ( bool _value, int idBrume )
	{
		isInBrume = _value;
		mylocalPlayer.ChangeFowRaduis(_value);

		brumeId = idBrume;
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

			case En_SpellInput.ThirdSpell:
				thirdSpell.ReduceCooldown(_duration);
				break;

			case En_SpellInput.Click:
				leftClick.ReduceCooldown(_duration);
				break;

			case En_SpellInput.Ward:
				ward.ReduceCooldown(_duration);
				break;
		}
	}

	void ReduceAllCooldowns ( float _duration )
	{
		firstSpell.ReduceCooldown(_duration);
		secondSpell.ReduceCooldown(_duration);
		thirdSpell.ReduceCooldown(_duration);
		//leftClick.ReduceCooldown(_duration);
		ward.ReduceCooldown(_duration);
	}

	//vision
	#region
	void CheckForBrumeRevelation ()
	{

		if (GameManager.Instance.currentLocalPlayer == null)
		{
			return;
		}
		if (ShouldBePinged())
		{
			Instantiate(sonar, transform.position + Vector3.up, Quaternion.Euler(90, 0, 0));
		}
		lastRecordedPos = transform.position;

	}

	bool ShouldBePinged ()
	{
		if (cursedByShili)
			return true;

		if (lastRecordedPos == transform.position || isInBrume)
			return false;

		PlayerModule _localPlayer = GameManager.Instance.currentLocalPlayer.myPlayerModule;

		if (!_localPlayer.isInBrume || (state & En_CharacterState.Crouched) != 0)
			return false;

		if (Vector3.Distance(transform.position, _localPlayer.transform.position) >= _localPlayer.characterParameters.detectionRange)
			return false;



		return true;
	}

	IEnumerator WaitForVisionCheck ()
	{
		CheckForBrumeRevelation();
		yield return new WaitForSeconds(characterParameters.delayBetweenDetection);
		StartCoroutine(WaitForVisionCheck());
	}
	#endregion

	//Vars 
	#region 
	public Vector3 directionInputed ()
	{
		return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
	}

	public Vector3 mousePos ()
	{
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		RaycastHit hit;

		if (Physics.Raycast(ray, out hit, Mathf.Infinity, 1<<10))
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
				allEffectLive[i].liveLifeTime -= Time.fixedDeltaTime;

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
			allTickLive[i].liveLifeTime -= Time.fixedDeltaTime;
			allTickLive[i].lastTick += Time.fixedDeltaTime;

			if (allTickLive[i].liveLifeTime <= 0)
			{
				_tempList.Add(allTickLive[i]);
			}

			if (allTickLive[i].lastTick >= allTickLive[i].effect.tickRate && allTickLive[i].liveLifeTime > 0)
			{
				allTickLive[i].lastTick = 0;

				if (allTickLive[i].effect.isDamaging)
				{
					DamagesInfos _temp = new DamagesInfos();
					_temp.damageHealth = allTickLive[i].effect.tickValue;

					this.mylocalPlayer.DealDamages(_temp, transform.position);
				}
				if (allTickLive[i].effect.isHealing)
				{
					this.mylocalPlayer.HealPlayer(allTickLive[i].effect.tickValue);
				}
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

		if (_statusToAdd.forcedKey != 0)
		{
			_newElement.key = _statusToAdd.forcedKey;
		}
		else
		{
			_newElement.key = currentKeyIndex;
			currentKeyIndex++;
		}

		if (_tempTrad.tick)
		{
			if (_tempTrad.refreshOnApply)
			{
				EffectLifeTimed _temp = GetTickEffectByKey(_newElement.key);

				if (_temp != null)
				{
					_temp.Refresh();
					return;
				}

			}
			allTickLive.Add(_newElement);
		}
		else
		{
			if (_tempTrad.refreshOnApply)
			{
				EffectLifeTimed _temp = GetEffectByKey(_newElement.key);

				if (_temp != null)
				{
					_temp.Refresh();
					return;
				}
			}
			allEffectLive.Add(_newElement);
		}

	}
	private EffectLifeTimed GetTickEffectByKey ( ushort key )
	{
		foreach (EffectLifeTimed effect in allTickLive)
		{
			if (effect.key == key)
			{
				return effect;
			}
		}

		return null;
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
	public void StopStatus ( ushort key )
	{
		EffectLifeTimed _temp = allEffectLive.Where(x => x.key == key).FirstOrDefault();

		if (_temp != null)
		{
			_temp.Stop();
		}
	}
	public void StopTickStatus ( ushort key )
	{
		EffectLifeTimed _temp = allEffectLive.Where(x => x.key == key).FirstOrDefault();

		if (_temp != null)
		{
			_temp.Stop();
		}
	}
	public void AddState(En_CharacterState _stateToadd)
	{
		_state |= _stateToadd;
	}

	public void RemoveState(En_CharacterState _stateToRemove)
	{
		_state = (_state & ~_stateToRemove);
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
	public void ApplyPoisonousBuffInServer ()
	{
		isPoisonousEffectActive = true;
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

	internal void ApplyWxMark()
	{
		EffectLifeTimed _temp = allEffectLive.Where(x => x.key == wxMarkRef.effect.forcedKey).FirstOrDefault();

		if (_temp != null)
		{
			_temp.Stop();

			DamagesInfos _tempDamages = new DamagesInfos();
			_tempDamages.damageHealth = wxMarkRef.effect.optionalDamages;

			this.mylocalPlayer.DealDamages(_tempDamages, transform.position);
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
	Stunned = Silenced | Root,
	slowedAndSped = SpedUp | Slowed | Clear,
	RootAndSlow = Root |Slowed | Clear,
	SlowedAndSIlenced = Slowed |Silenced | Clear
}

[System.Serializable]
public class DamagesInfos
{
	public ushort damageHealth;
	public Sc_Status[] statusToApply;
	public Sc_ForcedMovement movementToApply = null;
	[HideInInspector] public string playerName;
}

[System.Serializable]
public class Effect
{
	public bool tick = false;

	[HorizontalGroup("Group2")] [HideIf("isConstant")] public float finalLifeTime;
	[HorizontalGroup("Group2")]  public bool isConstant = false;
	[HorizontalGroup("Group1")] public bool canBeForcedStop = false;
	[HorizontalGroup("Group1")] [ShowIf("canBeForcedStop")] public ushort forcedKey = 0;
	public bool refreshOnApply = false;

	[ShowIf("tick")] [BoxGroup("Tick")] public float tickRate = 0.2f;
	[ShowIf("tick")] [BoxGroup("Tick")] public bool isDamaging = true;
	[ShowIf("tick")] [BoxGroup("Tick")] public bool isHealing = false;
	[ShowIf("tick")] [BoxGroup("Tick")] public ushort tickValue = 0;

	public En_CharacterState stateApplied;
	bool isMovementOriented => ((stateApplied & En_CharacterState.Slowed) != 0 || (stateApplied & En_CharacterState.SpedUp) != 0);
	[Range(0, 1)] [ShowIf("isMovementOriented")] public float percentageOfTheMovementModifier = 1;
	[ShowIf("isMovementOriented")] public AnimationCurve decayOfTheModifier = AnimationCurve.Constant(1, 1, 1);

	public ushort optionalDamages = 0;
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