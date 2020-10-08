using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MovementModule : MonoBehaviour
{
	St_MovementParameters parameters;
	float timeSpentRunning;
	bool running;
	CapsuleCollider collider;
	List<ForcedMovement> allForcedMovement = new List<ForcedMovement>();

	[SerializeField] LayerMask allBlockingLayer;

	public void OnEnable ()
	{
		PlayerModule.DirectionInputedUpdate += Move;
		PlayerModule.ToggleRunning += ToggleRunning;
		PlayerModule.StopRunning += StopRunning;
	}

	void OnDisable()
	{
		PlayerModule.DirectionInputedUpdate -= Move; 
		PlayerModule.ToggleRunning -= ToggleRunning;
		PlayerModule.StopRunning -= StopRunning;
	}

	public void SetupComponent ( St_MovementParameters _newParameters, CapsuleCollider _colliderInfos )
	{
		parameters = _newParameters;
		collider = _colliderInfos;
	}

	void Move (Vector3 _directionInputed)
	{
		if (ForcedMovement() != Vector3.zero)
		{
			if (isFree(ForcedMovement()))
				transform.position += ForcedMovement() * parameters.movementSpeed * Time.deltaTime;
			else
				ForcedMovementTouchObstacle();
		}
		else if (_directionInputed != Vector3.zero)
		{
			if (!isFree(_directionInputed))
			{
				transform.position += SlideVector(_directionInputed) * liveMoveSpeed() * Time.deltaTime;
			}
			else
			{
				transform.position += _directionInputed * liveMoveSpeed() * Time.deltaTime;
			}

			if(running == true)
			{
				timeSpentRunning += Time.deltaTime;
			}
		}
		else
		{
			StopRunning();
		}

		print(_directionInputed);
	}

	void ForcedMovementTouchObstacle()
	{
		allForcedMovement.Clear();
	}
	void AddDash ( ForcedMovement infos )
	{
		allForcedMovement.Add(infos);
	}
	void StopRunning()
	{
		timeSpentRunning = 0;
		running = false;
	}

	void StartRunning()
	{
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
	Vector3 ForcedMovement ()
	{
		Vector3 _forceToApply = Vector3.zero;

		if (allForcedMovement.Count > 0)
		{
			List<ForcedMovement> _movementToKeep = new List<ForcedMovement>();

			foreach (ForcedMovement _movement in allForcedMovement)
			{
				_forceToApply += (_movement.direction * _movement.strength);

				_movement.duration -= Time.deltaTime;
				if (_movement.duration > 0)
					_movementToKeep.Add(_movement);
			}

			allForcedMovement = _movementToKeep;
		}

		return _forceToApply;
	}
	Vector3 SlideVector ( Vector3 _directionToSlideFrom )
	{
		RaycastHit _hitToRead = CastCapsuleHit(_directionToSlideFrom)[0];


		Vector3 _aVector = new Vector3(-_hitToRead.normal.z, 0, _hitToRead.normal.x);
		Vector3 _bVector = new Vector3(_hitToRead.normal.z, 0, -_hitToRead.normal.x);

		if (Vector3.Dot(_directionToSlideFrom, _aVector) > 0)
		{
			if (isFree(_aVector))
				return _aVector;
			else
				return Vector3.zero;
		}
		else if (Vector3.Dot(_directionToSlideFrom, _bVector) > 0)
		{
			if (isFree(_bVector))
			{
				return _bVector;
			}
			else
				return Vector3.zero;
		}
		else
			return Vector3.zero;

	}
	public bool isFree ( Vector3 _direction )
	{
		if (CastCapsuleHit(_direction).Count > 0)
			return false;
		else
			return true;
	}
	bool canMove ()
	{
		return true;
	}
	float liveMoveSpeed()
	{
		float defspeed = parameters.movementSpeed + parameters.accelerationCurve.Evaluate(timeSpentRunning) * parameters.bonusRunningSpeed;

		// A RAJOUTER LES SLOWS A VOIR CE COMMENT QU ON FAIT 
		return defspeed;
	}

	List<RaycastHit> CastCapsuleHit ( Vector3 _direction )
	{
		List<RaycastHit> _allHit = Physics.CapsuleCastAll(transform.position - new Vector3(0, collider.height / 2, 0),
			transform.position + new Vector3(0, collider.height / 2, 0),
			collider.radius,
			_direction,
			collider.radius,
			allBlockingLayer).ToList<RaycastHit>();

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

	#endregion

}

[System.Serializable]
public class ForcedMovement
{
	public float duration;
	public Vector3 direction;
	public float strength;
}