using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting.Messaging;
using UnityEngine;


[CreateAssetMenu(fileName = "NewCharacter", menuName = "CreateCuston/NewCharacter")]
public class Sc_CharacterParameters : ScriptableObject
{
	public St_MovementParameters movementParameters;
	public ushort health;

	[Header("Vision Parameters")]
	public ushort visionRange, detectionRange = 10, delayBetweenDetection = 2;
}

[System.Serializable]
public struct St_MovementParameters
{
	public float movementSpeed;
	public float accelerationTime, bonusRunningSpeed;
	public AnimationCurve accelerationCurve;
	public float maxStamina, regenDelay, regenPerSecond;
}