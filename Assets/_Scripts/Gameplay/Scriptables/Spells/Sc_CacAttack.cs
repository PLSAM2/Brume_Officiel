using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCacSpell", menuName = "CreateCuston/NewSpell/CacAttack")]
public class Sc_CacAttack : Sc_Spell
{
	[Header("AutoParameters")]
	[TabGroup("Cac Parameters")] public float timeToCanalyseToUpgrade = .5f;
	[Header("DamagePart")]
	[TabGroup("Cac Parameters")] public CacAttackParameters normalAttack;
	[TabGroup("Cac Parameters")] public CacAttackParameters upgradedAttack;
}


[System.Serializable]
public class CacAttackParameters
{
	[Header("Hit Part")]
	public float angleToAttackFrom = 90;
	public float rangeOfTheAttack = 3;

	[Header("Damage Part")]
	public DamagesInfos damagesToDeal;
}
