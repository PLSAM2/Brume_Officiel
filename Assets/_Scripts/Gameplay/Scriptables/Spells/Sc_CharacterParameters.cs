using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting.Messaging;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCharacter", menuName = "CreateCuston/NewCharacter")]
public class Sc_CharacterParameters : ScriptableObject
{
	public ushort maxHealth;
	public ushort maxUltimateStack;

	[Header("Movement Parameters")]
	public St_MovementParameters movementParameters;

	[Header("Vision Parameters")]
	public ushort visionRange;
	public ushort visionRangeInBrume;
	public ushort detectionRange = 10; 
	public float delayBetweenDetection = 2;

    public AnimationCurve curveInBrume;
    public AnimationCurve curveOutBrume;
}

[System.Serializable]
public struct St_MovementParameters
{
	public float movementSpeed, crouchingSpeed;
/*	public float accelerationTime, bonusRunningSpeed;
	public AnimationCurve accelerationCurve;
public float maxStamina, regenDelay, regenPerSecond;*/
}