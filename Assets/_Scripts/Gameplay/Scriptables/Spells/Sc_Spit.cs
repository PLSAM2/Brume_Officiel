using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
[CreateAssetMenu(fileName = "NewSpit", menuName = "CreateCuston/NewSpell/NewSpit")]

public class Sc_Spit : Sc_Spell
{
	[TabGroup("Spit  Parameters")] public Aoe onImpactInstantiate;
	[TabGroup("Spit  Parameters")] public AnimationCurve launchCurve;
	
	[Header("simpleSpeed")]
	[TabGroup("Spit  Parameters")] public float spitSpeed;
	[Header("Not simpleSpeed")]
	[TabGroup("Spit  Parameters")] public float timeToReachMaxRange= .75f;
	[TabGroup("Spit  Parameters")] public float minTimeToReach, minHeight = 3, maxHeightAtMaxRange= 6;
}

