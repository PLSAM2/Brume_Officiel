using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MovementModule : MonoBehaviour
{
	[Header("Basic elements")]
	St_MovementParameters parameters;
	[SerializeField] LayerMask movementBlockingLayer, dashBlockingLayer ;
	[SerializeField] En_CharacterState forbidenWalkingState = En_CharacterState.Canalysing | En_CharacterState.Stunned;
	CapsuleCollider collider;

	[Header("Running Stamina")]
	[SerializeField] bool usingStamina;
	float timeSpentRunning,  timeSpentNotRunning, _stamina;
	public float Stamina {	get => _stamina; 
		set { 
			_stamina = value;
			UiManager.Instance.UpdateUiCooldownSpell(En_SpellInput.Maj, _stamina , parameters.maxStamina); 	} 
	}
	bool running = false;
	//DASH 
	ForcedMovement currentForcedMovement = new ForcedMovement();

	//recup des actions
	PlayerModule myPlayerModule;

	public void OnEnable ()
	{
		myPlayerModule = GetComponent<PlayerModule>();

		myPlayerModule.DirectionInputedUpdate += Move;
		myPlayerModule.forcedMovementAdded += AddDash;

		/*myPlayerModule.toggleRunning += ToggleRunning;
		myPlayerModule.stopRunning += StopRunning;*/

		//IMPORTANT POUR LES CALLBACKS
		currentForcedMovement.myModule = myPlayerModule;

	}

	void OnDisable()
	{
		myPlayerModule.DirectionInputedUpdate -= Move;
		myPlayerModule.toggleRunning -= ToggleRunning;
		myPlayerModule.stopRunning -= StopRunning;
	}

	public void SetupComponent ( St_MovementParameters _newParameters, CapsuleCollider _colliderInfos )
	{
		parameters = _newParameters;
		collider = _colliderInfos;

		//stamina
		_stamina = parameters.maxStamina;
		Stamina = parameters.maxStamina;
	}

	void Move (Vector3 _directionInputed)
	{
		//forceMovement
		if (currentForcedMovement.duration > 0)
		{
			currentForcedMovement.duration -= Time.deltaTime;

			if (isFree(currentForcedMovement.direction, dashBlockingLayer))
				transform.position += currentForcedMovement.direction * currentForcedMovement.strength * Time.deltaTime;
			else
				ForcedMovementTouchObstacle();
		}
		//movement normal
		else if (_directionInputed != Vector3.zero && canMove())
		{
			//Mouvement Modifier via bool
			if (running == true)
			{
				timeSpentRunning += Time.deltaTime;
				Stamina -= Time.deltaTime;
				if (Stamina <= 0 && usingStamina)
					myPlayerModule.stopRunning.Invoke();
			}
			else
			{
				StopRunning();
			}

			//marche
			if (!isFree(_directionInputed, movementBlockingLayer))
			{
				transform.position += SlideVector(_directionInputed) * liveMoveSpeed() * Time.deltaTime;
			}
			else
			{
				transform.position += _directionInputed * liveMoveSpeed() * Time.deltaTime;
			}
			myPlayerModule.onSendMovement(_directionInputed);
		}
		else
			myPlayerModule.onSendMovement(Vector3.zero);


		//Stamina
		if (!running && usingStamina)
		{
			if (timeSpentNotRunning > parameters.regenDelay)
				Stamina = Mathf.Clamp(Stamina +  Time.deltaTime * parameters.regenPerSecond,0 , parameters.maxStamina);
			else
				timeSpentNotRunning += Time.deltaTime;
		}
	}

	void ForcedMovementTouchObstacle()
	{
		//juste pour caler le callback comme quoi le mouvement est bien fini;
		currentForcedMovement.duration = 0;
		currentForcedMovement = new ForcedMovement();
		currentForcedMovement.myModule = myPlayerModule;

	}
	public void AddDash ( ForcedMovement infos )
	{
		currentForcedMovement = infos;
		currentForcedMovement.myModule = myPlayerModule;
	}

	void StopRunning()
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
	}

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
		RaycastHit _hitToRead = CastCapsuleHit(_directionToSlideFrom, movementBlockingLayer)[0];


		Vector3 _aVector = new Vector3(-_hitToRead.normal.z, 0, _hitToRead.normal.x);
		Vector3 _bVector = new Vector3(_hitToRead.normal.z, 0, -_hitToRead.normal.x);

		if (Vector3.Dot(_directionToSlideFrom, _aVector) > 0)
		{
			if (isFree(_aVector, movementBlockingLayer))
				return _aVector;
			else
				return Vector3.zero;
		}
		else if (Vector3.Dot(_directionToSlideFrom, _bVector) > 0)
		{
			if (isFree(_bVector, movementBlockingLayer))
			{
				return _bVector;
			}
			else
				return Vector3.zero;
		}
		else
			return Vector3.zero;

	}
	public bool isFree ( Vector3 _direction, LayerMask _layerTocheck )
	{
		if (CastCapsuleHit(_direction, _layerTocheck).Count > 0)
			return false;
		else
			return true;
	}
	bool canMove ()
	{
		if ((myPlayerModule.state & forbidenWalkingState) != 0)
			return false;
		else
			return true;
	}
	float liveMoveSpeed()
	{
		float defspeed = parameters.movementSpeed + parameters.accelerationCurve.Evaluate(timeSpentRunning/ parameters.accelerationTime) * parameters.bonusRunningSpeed;

		// A RAJOUTER LES SLOWS A VOIR CE COMMENT QU ON FAIT 
		return defspeed;
	}

	List<RaycastHit> CastCapsuleHit ( Vector3 _direction , LayerMask _checkingLayer)
	{
		List<RaycastHit> _allHit = Physics.CapsuleCastAll(transform.position,
			transform.position + new Vector3(0, collider.height, 0),
			collider.radius,
			_direction,
			collider.radius,
			_checkingLayer).ToList<RaycastHit>();


		List<RaycastHit> _returnList = new List<RaycastHit>();

		for (int i = 0; i < _allHit.Count; i++)
		{
			if (_allHit[i].collider.gameObject != this.gameObject)
			{
				_returnList.Add(_allHit[i]);
			}
		}
		return _returnList;
	}


	private void OnDrawGizmosSelected ()
	{
		//Gizmos.DrawSphere(transform.position + new Vector3(.3f, 1.5f,0), .3f);
	}
	#endregion
}

[System.Serializable]
public class ForcedMovement
{
	public PlayerModule myModule;
	float _duration = 0;
	public float duration
	{
		get => _duration; set
		{
			_duration = value; if (_duration <= 0) { myModule.forcedMovementInterrupted.Invoke(); }
		}
	}
	Vector3 _direction;
	public Vector3 direction { get => _direction; set { _direction = Vector3.Normalize(value); } }
	public float strength;
}

[System.Serializable]
public class MovementModifier
{
	public float percentageOfTheModifier, duration;
}
