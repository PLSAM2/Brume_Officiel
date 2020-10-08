using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[CreateAssetMenu(menuName = "CreateNewCharacter", fileName ="NewCharaParameters")]
public class Sc_CharacterParameters : ScriptableObject
{
	public St_MovementParameters movementParameters;
}

[System.Serializable]
public struct St_MovementParameters
{
	public float movementSpeed;
	public float accelerationTime, bonusRunningSpeed;
	public AnimationCurve accelerationCurve;
	public float maxStamina, regenDelay, regenPerSecond;
}