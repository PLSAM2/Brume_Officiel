using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MovementModule : MonoBehaviour
{

	[Header("Basic elements")]
	St_MovementParameters parameters;
	public LayerMask movementBlockingLayer, dashBlockingLayer;
	[SerializeField] En_CharacterState forbidenWalkingState = En_CharacterState.Stunned | En_CharacterState.Root;
	[SerializeField] CharacterController chara;
	[HideInInspector] public bool rotLocked = false;
	[HideInInspector] public CapsuleCollider collider;

	/*	[Header("Running Stamina")]
		[SerializeField] bool usingStamina;
		float timeSpentRunning,  timeSpentNotRunning, _stamina;
		public float Stamina {	get => _stamina; 
			set { 
				_stamina = value;
				UiManager.Instance.UpdateUiCooldownSpell(En_SpellInput.Maj, _stamina , parameters.maxStamina); 	} 
		}
		bool running = false;*/
	//DASH 
	[ReadOnly] public ForcedMovement currentForcedMovement = null;
	//recup des actions
	PlayerModule myPlayerModule;
	private bool isAGhost = false;
	public float ghostSpeed = 4.2f;
	public void Start ()
	{
		if (!isAGhost)
		{
			Init();
		}

	}



	public void Init ()
	{
		if (GetComponent<Ghost>() != null)
		{
			isAGhost = true;
		}

		if (isAGhost)
		{
			myPlayerModule = GetComponent<Ghost>().playerModule;
		}
		else
		{
			myPlayerModule = GetComponent<PlayerModule>();
		}


		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			myPlayerModule.DirectionInputedUpdate += Move;
			myPlayerModule.forcedMovementAdded += AddDash;
		}


		/*myPlayerModule.toggleRunning += ToggleRunning;
		myPlayerModule.stopRunning += StopRunning;*/

		//IMPORTANT POUR LES CALLBACKS
		if (!isAGhost)
		{
			currentForcedMovement.myModule = myPlayerModule;
			collider = GetComponent<CapsuleCollider>();
		}
	}

	void OnDisable ()
	{
		if (myPlayerModule == null)
		{
			return;
		}

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			myPlayerModule.DirectionInputedUpdate -= Move;
			myPlayerModule.forcedMovementAdded -= AddDash;
		}
		//	myPlayerModule.toggleRunning -= ToggleRunning;
		//	myPlayerModule.stopRunning -= StopRunning;
	}

	public void SetupComponent ( St_MovementParameters _newParameters )
	{
		parameters = _newParameters;
		//stamina
		//_stamina = parameters.maxStamina;
		//Stamina = parameters.maxStamina;
	}

	void FixedUpdate ()
	{
		transform.position = new Vector3(transform.position.x, 0, transform.position.z);
	}

	void Move ( Vector3 _directionInputed )
	{
		//forceMovement
		if (currentForcedMovement != null)
		{

			currentForcedMovement.duration -= Time.deltaTime;
			if (currentForcedMovement.duration <= 0)
			{
				currentForcedMovement = null;
				myPlayerModule.forcedMovementInterrupted?.Invoke();
				return;
			}
			if (IsFree(currentForcedMovement.direction, dashBlockingLayer, currentForcedMovement.strength * Time.deltaTime))
			{
			chara.Move(new Vector3(currentForcedMovement.direction.x, 0, currentForcedMovement.direction.z) * (currentForcedMovement.strength * currentForcedMovement.speedEvolution.Evaluate(currentForcedMovement.duration/ currentForcedMovement.baseDuration) )* Time.deltaTime);
			}
			else
			{
				ForcedMovementTouchObstacle();
			}

		}
		//movement normal
		else if (_directionInputed != Vector3.zero && CanMove())
		{
			chara.Move(_directionInputed * LiveMoveSpeed() * Time.deltaTime);

			myPlayerModule.onSendMovement(_directionInputed);
		}
		else
		{
			myPlayerModule.onSendMovement(Vector3.zero);
		}
	}

	void ForcedMovementTouchObstacle ()
	{
		//juste pour caler le callback comme quoi le mouvement est bien fini;
		currentForcedMovement.duration = 0;
	}

	public void AddDash ( ForcedMovement infos )
	{
		ForcedMovement _temp = new ForcedMovement();
		_temp.direction = infos.direction;
		_temp.duration = infos.duration;
		_temp.baseDuration = infos.baseDuration;
		_temp.strength = infos.strength;
		_temp.myModule = myPlayerModule;
		currentForcedMovement = _temp;
	}

	private void Update ()
	{
		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			//rot player
			LookAtMouse();
		}
		else
			return;
	}
	void LookAtMouse ()
	{
		if (!rotLocked)
		{
			Vector3 _currentMousePos = myPlayerModule.mousePos();
			transform.LookAt(new Vector3(_currentMousePos.x, transform.position.y, _currentMousePos.z));
		}
	}
	/*void StopRunning()
	{
		timeSpentRunning = 0;
		running = false;
	}

	void StartRunning()
	{
		timeSpentNotRunning = 0;
		running = true;
	}

	void ToggleRunning()
	{
		if (running)
			StopRunning();
		else
			StartRunning();
	}*/


	//Parameters
	#region
	/* si plusieurs mouvement forcé en même temps s additione;
	Vector3 ForcedMovement ()
	{
		Vector3 _forceToApply = Vector3.zero;

		if (allForcedMovement.Count > 0)
		{
			List<ForcedMovement> _movementToKeep = new List<ForcedMovement>();

			foreach (ForcedMovement _movement in allForcedMovement)
			{
				_forceToApply += (Vector3.Normalize(_movement.direction) * _movement.strength);
				_movement.duration -= Time.deltaTime;

				if (_movement.duration > 0)
					_movementToKeep.Add(_movement);
			}

			allForcedMovement = _movementToKeep;
		}

		return _forceToApply;
	}*/

	Vector3 SlideVector ( Vector3 _directionToSlideFrom )
	{
		RaycastHit _hitToRead = CastSphereAll(_directionToSlideFrom, movementBlockingLayer, collider.radius)[0];


		Vector3 _aVector = new Vector3(-_hitToRead.normal.z, 0, _hitToRead.normal.x);
		Vector3 _bVector = new Vector3(_hitToRead.normal.z, 0, -_hitToRead.normal.x);

		if (Vector3.Dot(_directionToSlideFrom, _aVector) > 0)
		{
			if (IsFree(_aVector, movementBlockingLayer, collider.radius))
				return _aVector;
			else
				return Vector3.zero;
		}
		else if (Vector3.Dot(_directionToSlideFrom, _bVector) > 0)
		{
			if (IsFree(_bVector, movementBlockingLayer, collider.radius))
			{
				return _bVector;
			}
			else
				return Vector3.zero;
		}
		else
			return Vector3.zero;

	}

	public bool IsFree ( Vector3 _direction, LayerMask _layerTocheck, float _maxRange )
	{
		if (CastSphereAll(_direction, _layerTocheck, _maxRange) != null)
			return false;
		else
			return true;
	}

	bool CanMove ()
	{
		if (isAGhost)
			return true;

		if ((myPlayerModule.state & forbidenWalkingState) != 0 || currentForcedMovement != null)
		{
			return false;
		}
		else
			return true;
	}

	float LiveMoveSpeed ()
	{
		if (isAGhost)
		{
			return ghostSpeed;
		}



		float _worstMalus = 0;
		float _allBonuses = 0;

		foreach (EffectLifeTimed _liveEffect in myPlayerModule.allEffectLive)
		{
			if ((_liveEffect.effect.stateApplied & En_CharacterState.Slowed) != 0)
			{
				if (_liveEffect.effect.percentageOfTheMovementModifier > _worstMalus)
					_worstMalus = _liveEffect.effect.percentageOfTheMovementModifier;
			}
			else if ((_liveEffect.effect.stateApplied & En_CharacterState.SpedUp) != 0)
			{
				_allBonuses += _liveEffect.effect.percentageOfTheMovementModifier;
			}
		}
		/*float defspeed = parameters.movementSpeed + parameters.accelerationCurve.Evaluate(timeSpentRunning/ parameters.accelerationTime) * parameters.bonusRunningSpeed;*/

		float _baseSpeed = 0;

		if ((myPlayerModule.state & En_CharacterState.Crouched) != 0)
			_baseSpeed = parameters.crouchingSpeed;

		else
			_baseSpeed = parameters.movementSpeed;


		return _baseSpeed * (1 + _allBonuses) * (1 - _worstMalus);

	}

	List<RaycastHit> CastSphereAll ( Vector3 _direction, LayerMask _checkingLayer, float _maxRange )
	{
		List<RaycastHit> _allHit = Physics.SphereCastAll(transform.position,
			collider.radius,
			_direction,
			_maxRange,
			_checkingLayer).ToList<RaycastHit>();

		Debug.DrawLine(transform.position, (_direction * _maxRange + transform.position), Color.red);

		List<RaycastHit> _returnList = new List<RaycastHit>();
		if (_allHit.Count > 0)
		{
			for (int i = 0; i < _allHit.Count; i++)
			{
				if (_allHit[i].collider.gameObject != this.gameObject)
				{
					_returnList.Add(_allHit[i]);
				}
			}
			return _returnList;
		}
		else
			return null;
	}
	#endregion
}

[System.Serializable]
public class ForcedMovement
{
	[HideInInspector] public PlayerModule myModule;
	[SerializeField] float _duration = 0;

	public float duration
	{
		get => _duration;
		set
		{
			_duration = value;
		}
	}
	public float baseDuration;
	public AnimationCurve speedEvolution = new AnimationCurve(new Keyframe(1, 1), new Keyframe(1, 1));
	Vector3 _direction;
	public Vector3 direction { get => _direction; set { _direction = Vector3.Normalize(value); } }
	public float strength;
	[ReadOnly] public float length => duration * strength;
}