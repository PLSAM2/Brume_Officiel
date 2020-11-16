﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;
using System.Net.Http.Headers;
using DG.Tweening;
using static GameData;

public class PlayerModule : MonoBehaviour
{
	[Header("Inputs")]
	public KeyCode firstSpellKey = KeyCode.A;
	public KeyCode secondSpellKey = KeyCode.E, thirdSpellKey = KeyCode.R, freeCamera = KeyCode.Space, crouching = KeyCode.LeftShift;
	public KeyCode interactKey = KeyCode.F;
	public KeyCode wardKey = KeyCode.Alpha4;
	private LayerMask groundLayer;
	bool rotLocked = false;

	[Header("GameplayInfos")]
	public Sc_CharacterParameters characterParameters;
	[ReadOnly] public Team teamIndex;
	[ReadOnly] public bool isInBrume = false;
	[ReadOnly] public int brumeId;
	Vector3 lastRecordedPos;

	[Header("DamagesPart")]
	En_CharacterState _state;
	bool isCrouched=false;
	[ReadOnly] public En_CharacterState state { get => _state; set { _state = value; if (mylocalPlayer.isOwner) { UiManager.Instance.StatusUpdate(_state); } } }
	[HideInInspector] public List<DamagesInfos> allHitTaken = new List<DamagesInfos>();


	[Header("Vision")]
	public GameObject sonar;
	public LayerMask brumeLayer;
	[SerializeField] SpriteRenderer mapIcon;

	[Header("CharacterBuilder")]
	public MovementModule movementPart;
	[SerializeField] SpellModule firstSpell, secondSpell, thirdSpell, leftClick, ward;
	[SerializeField] CapsuleCollider coll;
	[HideInInspector] public LocalPlayer mylocalPlayer;

	//interactibles
	[HideInInspector] public List<Interactible> interactiblesClose = new List<Interactible>();
	[HideInInspector] public List<PlayerSoul> playerSouls = new List<PlayerSoul>();
	[HideInInspector] public List<EffectLifeTimed> allStatusLive;


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
		groundLayer = LayerMask.GetMask("Ground");
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

		state = En_CharacterState.Clear;

		if (mylocalPlayer.isOwner)
		{
			_state = En_CharacterState.Clear;
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
			//rot player
			LookAtMouse();

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
			else if (Input.GetAxis("Fire1") > 0)
			{
				leftClickInput?.Invoke(mousePos());
			}
			//RUNNING
			else if (Input.GetKeyDown(KeyCode.LeftShift))
				startSneaking?.Invoke();

			if (Input.GetKeyUp(firstSpellKey))
				firstSpellInputRealeased?.Invoke(mousePos());
			else if (Input.GetKeyDown(secondSpellKey))
				secondSpellInputRealeased?.Invoke(mousePos());
			else if (Input.GetKeyDown(thirdSpellKey))
				thirdSpellInputRealeased?.Invoke(mousePos());
			else if (Input.GetKeyDown(wardKey))
				wardInputReleased?.Invoke(mousePos());


			if (Input.GetKeyDown(interactKey))
			{
				foreach (Interactible interactible in interactiblesClose)
				{
					if (interactible == null)
						return;

					interactible.TryCapture(teamIndex, this);
				}
			}
			else if (Input.GetKeyUp(interactKey))
			{
				foreach (Interactible interactible in interactiblesClose)
				{
					if (interactible == null)
						return;

					interactible.StopCapturing(teamIndex);
				}
			}

			if (Input.GetKeyDown(crouching))
				isCrouched = true;

			else if (Input.GetKeyUp(crouching))
				isCrouched = false;

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
	}

	public virtual void SetInBrumeStatut ( bool _value, int idBrume)
	{
		isInBrume = _value;
		mylocalPlayer.ChangeFowRaduis(_value);

		brumeId = idBrume;
	}

	void LookAtMouse ()
	{
		if (!rotLocked)
		{
			Vector3 _currentMousePos = mousePos();
			transform.LookAt(new Vector3(_currentMousePos.x, transform.position.y, _currentMousePos.z));
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
			GameObject _fx = Instantiate(sonar, transform.position + Vector3.up, Quaternion.Euler(90, 0, 0));

			if (teamIndex == Team.blue)
			{
				_fx.GetComponent<ParticleSystem>().startColor = Color.blue;
			}
			else if (teamIndex == Team.red)
			{
				_fx.GetComponent<ParticleSystem>().startColor = Color.red;
			}
		}

	}

	bool ShouldBePinged ()
	{
		if (lastRecordedPos == transform.position)
			return false;

		lastRecordedPos = transform.position;
		PlayerModule _localPlayer = GameManager.Instance.currentLocalPlayer.myPlayerModule;

		if (!_localPlayer.isInBrume)
			return false;

		if (Vector3.Distance(transform.position, _localPlayer.transform.position) > _localPlayer.characterParameters.detectionRange)
			return false;

		if (_localPlayer.isInBrume == isInBrume)
			return false;

		if (Vector3.Distance(_localPlayer.transform.position, transform.position) > _localPlayer.characterParameters.detectionRange)
			return false;

		if (Vector3.Distance(_localPlayer.transform.position, transform.position) < _localPlayer.characterParameters.visionRange)
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

		if (Physics.Raycast(ray, out hit, Mathf.Infinity, groundLayer))
		{
			return new Vector3(hit.point.x, 0, hit.point.z);
		}
		else
		{
			return Vector3.zero;
		}
	}

	public Vector3 ClosestFreePos ( Vector3 _posToCloseUpTo, float _anticipationDistance )
	{
		RaycastHit _hit;
		if (Physics.Raycast(transform.position, _posToCloseUpTo - transform.position, out _hit, 1000, movementPart.movementBlockingLayer))
		{
			return transform.position + Vector3.Normalize(_posToCloseUpTo - transform.position) * (Vector3.Distance(_hit.point, transform.position) - _anticipationDistance);
		}
		return transform.position;
	}
	#endregion

	void LockingRotation ( bool _isLocked )
	{
		if (_isLocked)
			rotLocked = true;
		else
			rotLocked = false;
	}

	public void PickPlayerSoul ( PlayerSoul playerSoul )
	{
		playerSouls.Add(playerSoul);
	}

	public void AddStatus( Effect _statusToAdd )
	{
		EffectLifeTimed _newElement = new EffectLifeTimed();
		_newElement.lifeTime = _statusToAdd.lifeTime;
		_newElement.effect = _statusToAdd;
		allStatusLive.Add(_newElement);
	}

	void TreatEffects()
	{
		En_CharacterState _stateToFinalyApply = En_CharacterState.Clear;

		if (allStatusLive.Count >0)
		{
			List<EffectLifeTimed> _tempList = allStatusLive;

			for (int i = 0; i < allStatusLive.Count; i++)
			{
				allStatusLive[i].lifeTime -= Time.fixedDeltaTime;
				_tempList[i].lifeTime -= Time.fixedDeltaTime;

				if (allStatusLive[i].lifeTime <= 0)
				{
					_tempList.Remove(allStatusLive[i]);
				}
				else
				{
					_stateToFinalyApply |= allStatusLive[i].effect.stateApplied;
				}
			}

			allStatusLive = _tempList;

		}
		if (isCrouched)
			state |= En_CharacterState.Crouched;

		if (state != _stateToFinalyApply)
		{
			state = _stateToFinalyApply;
			mylocalPlayer.SendState(state);
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
	Stunned = Silenced | Root,
}

[System.Serializable]
public class DamagesInfos
{
	public ushort damageHealth;

	[HideInInspector] public string playerName;
}

[System.Serializable]
public class Effect
{
	public float lifeTime;
	public En_CharacterState stateApplied;
	bool isMovementOriented => ((stateApplied & En_CharacterState.Slowed) != 0 || (stateApplied & En_CharacterState.SpedUp) != 0);
	[ShowIf("isMovementOriented")] public float percentageOfTheModifier=1;
	[ShowIf("isMovementOriented")] public AnimationCurve decayOfTheModifier= AnimationCurve.Constant(1,1,1);
}

[System.Serializable]
public class EffectLifeTimed
{
	public Effect effect;
	public float lifeTime;
}

