using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "newForcedMovement", menuName = "CreateCuston/NewFprcedMovement")]
public class Sc_ForcedMovement : ScriptableObject
{
	public ForcedMovement movementToApply;
	public bool isGrab, useForwardOfDealer = false;

	public ForcedMovement MovementToApply ( Vector3 _target, Vector3 _basePos, float percentageOfTheMovement = 1, float _forcedDirectionX = 0, float _forcedDirectionZ = 0 )
	{
		ForcedMovement _temp = new ForcedMovement();
		_temp.duration = movementToApply.duration;
		_temp.baseDuration = movementToApply.duration;
		_temp.speedEvolution = movementToApply.speedEvolution;



		_temp.direction = movementToApply.direction;
		_temp.strength = movementToApply.strength * percentageOfTheMovement;




		Vector3 _tempForcedDirection = new Vector3(_forcedDirectionX,0, _forcedDirectionZ);
		if (_tempForcedDirection != Vector3.zero)
		{
			_temp.direction = _tempForcedDirection; 
		}
		else
		{
			if (!isGrab)
				_temp.direction = Vector3.Normalize(_target - _basePos);
			else
				_temp.direction = Vector3.Normalize(_basePos - _target);
		}

		_temp.baseDuration = _temp.duration;
		return _temp;
	}
}
