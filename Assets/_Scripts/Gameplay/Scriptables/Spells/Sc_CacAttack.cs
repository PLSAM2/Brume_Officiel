using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCacSpell", menuName = "CreateCuston/NewSpell/CacAttack")]
public class Sc_CacAttack : Sc_Spell
{
	public bool newSystem = true;
	[Header("AutoParameters")]
	[HideIf("newSystem")] [TabGroup("Cac Parameters")] public float timeToCanalyseToUpgrade = .5f;
	[Header("DamagePart")]
	[HideIf("newSystem")] [TabGroup("Cac Parameters")] public CacAttackParameters normalAttack;
	[HideIf("newSystem")] [TabGroup("Cac Parameters")] public CacAttackParameters upgradedAttack;

	[Header("enchainement part")]
	[ShowIf("newSystem")] [TabGroup("Cac Parameters")] public CacAttackParameters[] attackList;
	[ShowIf("newSystem")] [TabGroup("Cac Parameters")] public float timeToStopCombo;
}


[System.Serializable]
public class CacAttackParameters
{
	[Header("Hit Part")]
	public float angleToAttackFrom = 90;
	public float rangeOfTheAttack = 3;

	[Header("Damage Part")]
	public DamagesInfos damagesToDeal;

	[Header("Canalisation Part")]
	public float canalisationTime;
	public float anonciationTime;

	[Header("Movement Part")]
	public Sc_ForcedMovement forcedMovementToApplyOnRealisation;
	public Sc_ForcedMovement forcedMovementToApplyAfterRealisation;
}
