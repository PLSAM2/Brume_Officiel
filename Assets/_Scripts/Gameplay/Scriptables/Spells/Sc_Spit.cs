using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewSpit", menuName = "CreateCuston/NewSpell/NewSpit")]

public class Sc_Spit : Sc_Spell
{
	public Aoe onImpactInstantiate;
	public float spitSpeed;
	public AnimationCurve launchCurve;
	public float timeToReachMaxRange;

	[Header("AoeParameters")]
	public float durationOfTheAoe, aoeRadius;
	public DamagesInfos damagesToDealOnImpact, damagesToDealOnDuration;
}
