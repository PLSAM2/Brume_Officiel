using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "newForcedMovement", menuName = "CreateCuston/NewFprcedMovement")]
public class Sc_ForcedMovement : ScriptableObject
{
	public ForcedMovement movementToApply;
	public bool isGrab= false;

	public ForcedMovement MovementToApply(Vector3 _target, Vector3 _basePos, float percentageOfTheMovement = 1)
	{
		ForcedMovement _temp = new ForcedMovement();
		_temp.duration = movementToApply.duration;
		_temp.baseDuration = movementToApply.duration;
		_temp.speedEvolution = movementToApply.speedEvolution;
		_temp.direction = movementToApply.direction;
		_temp.strength = movementToApply.strength * percentageOfTheMovement;


		if (!isGrab)
			_temp.direction = Vector3.Normalize(_target - _basePos);
		else
			_temp.direction = Vector3.Normalize( _basePos - _target);
		_temp.baseDuration = _temp.duration;
		return _temp;
	}
}
