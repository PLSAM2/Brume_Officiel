﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCacSpell", menuName = "CreateCuston/NewSpell/CacAttack")]
public class Sc_CacAttack : Sc_Spell
{
	[Header("AutoParameters")]
	[TabGroup("Cac Specification")] public float timeToCanalyseToUpgrade = .5f;
	public float timeToForceResolve;
	[Header("DamagePart")]
	[TabGroup("Cac Specification")] public CacAttackParameters normalAttack;
	[TabGroup("Cac Specification")] public CacAttackParameters upgradedAttack;

}


[System.Serializable]
public class CacAttackParameters
{
	[Header("hit Part")]
	[Tooltip("90")] public float angleToAttackFrom = 90;
	public float rangeOfTheAttack = 3;

	[Header("damage Part")]
	public DamagesInfos damagesToDeal;
}
