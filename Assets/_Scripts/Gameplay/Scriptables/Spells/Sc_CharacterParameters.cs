using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCharacter", menuName = "CreateCuston/NewCharacter")]
public class Sc_CharacterParameters : ScriptableObject
{
	public ushort maxHealth;
	public ushort maxHealthForRegen;

	[Header("Movement Parameters")]
	public St_MovementParameters movementParameters;

	[Header("Vision Parameters")]
	public ushort visionRange;
    public ushort minVisionRangeInBrume = 2;
    public ushort visionRangeInBrume = 5;
    public ushort detectionRange = 10; 
	public float delayBetweenDetection = 2;
}

[System.Serializable]
public struct St_MovementParameters
{
	public float movementSpeed, crouchingSpeed;
/*	public float accelerationTime, bonusRunningSpeed;
	public AnimationCurve accelerationCurve;
public float maxStamina, regenDelay, regenPerSecond;*/
}