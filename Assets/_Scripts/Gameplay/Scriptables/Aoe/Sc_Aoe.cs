using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "newAoe", menuName = "CreateCuston/NewAoeParameters")]
public class Sc_Aoe : ScriptableObject
{
	public AoeParameters rules;
	public float  cooldownReductionOnHit;
	public En_SpellInput  cooldownReducedOnHit;

	[TabGroup("Feedbacks")] public bool screenShake = false;
	[TabGroup("Feedbacks")] [ShowIf("screenShake")] public float intensity = 0.1f;
	[TabGroup("Feedbacks")] [ShowIf("screenShake")] public float duration = 0.1f;
}

[System.Serializable]
public class AoeParameters
{
	[Header("AoeParameters")]
	public float durationOfTheAoe, timeBeforeFinalDisparition;
	[TabGroup("Damages")] public DamagesInfos damagesToDealOnImpact, finalDamages;
	[TabGroup("Buff")] public DamagesInfos impactAlly, finalAlly;
	public bool useOwnerPos, forceForward = false;
	[Tooltip("De base c est une sphère")] public bool isBox;
	[HideIf("isBox")] public float aoeRadius;
	[ShowIf("isBox")] public Vector3 boxDimension;


}

