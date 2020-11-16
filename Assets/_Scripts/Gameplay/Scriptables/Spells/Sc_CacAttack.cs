using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCacSpell", menuName = "CreateCuston/NewSpell/CacAttack")]
public class Sc_CacAttack : Sc_Spell
{
	[Header("AutoParameters")]
	public List<CacAttackParameters> listOfAttacks;
}


[System.Serializable]
public class CacAttackParameters
{
	[Header("hit Part")]
	[Tooltip("90")] public float angleToAttackFrom = 90;
	public float rangeOfTheAttack = 3;

	[Header("Enchainement")]
	public float distanceToDash = .5F;
	public float dashDuration = 0.05f;
	public float bumpDistance = .5f, bumpDuration = .05f;
	public float delayWithNextAttack=.3f;

	[Header("damage Part")]
	public ushort damagesToDeal = 1;
}
