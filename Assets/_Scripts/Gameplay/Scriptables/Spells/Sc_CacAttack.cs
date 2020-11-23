using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCacSpell", menuName = "CreateCuston/NewSpell/CacAttack")]
public class Sc_CacAttack : Sc_Spell
{
	[Header("AutoParameters")]
	public float timeToCanalyseToUpgrade = .5f;
	public float timeToForceResolve;
	[Header("DamagePart")]
	public CacAttackParameters normalAttack;
	public CacAttackParameters upgradedAttack;

}


[System.Serializable]
public class CacAttackParameters
{
	[Header("hit Part")]
	[Tooltip("90")] public float angleToAttackFrom = 90;
	public float rangeOfTheAttack = 3;

	[Header("Enchainement")]
	public Sc_ForcedMovement movementOfTheCharacter;

	[Header("damage Part")]
	public DamagesInfos damagesToDeal;
}
