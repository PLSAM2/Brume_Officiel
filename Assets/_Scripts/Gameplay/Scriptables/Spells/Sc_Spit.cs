using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
[CreateAssetMenu(fileName = "NewSpit", menuName = "CreateCuston/NewSpell/NewSpit")]

public class Sc_Spit : Sc_Spell
{
	[TabGroup("Spit  Parameters")] public Aoe onImpactInstantiate;
	[TabGroup("Spit  Parameters")] public float spitSpeed;
	[TabGroup("Spit  Parameters")] public AnimationCurve launchCurve;
	[TabGroup("Spit  Parameters")] public float timeToReachMaxRange;

	[Header("AoeParameters")]
	[TabGroup("Spit  Parameters")] public float durationOfTheAoe, aoeRadius;
	[TabGroup("Spit  Parameters")] public DamagesInfos damagesToDealOnImpact, damagesToDealOnDuration;
}
