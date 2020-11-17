using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "newForcedMovement", menuName = "CreateCuston/NewFprcedMovement")]
public class Sc_ForcedMovement : ScriptableObject
{
	[SerializeField] ForcedMovement movementToApply;

	public ForcedMovement MovementToApply(Vector3 _target, Vector3 _basePos)
	{
		ForcedMovement _temp = new ForcedMovement();
		_temp = movementToApply;
		_temp.direction = Vector3.Normalize(_target - _basePos);
		return _temp;
	}
}
