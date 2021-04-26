using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewCacSpell", menuName = "CreateCuston/NewSpell/CacAttack")]
public class Sc_CacAttack : Sc_Spell
{
	[TabGroup("Cac Parameters")] public CacAttackParameters attackParameters;
}


[System.Serializable]
public class CacAttackParameters
{
	[Header("Hit Part")]
	public float widthToAttackFrom = 90;

	[Header("Damage Part")]
	public DamagesInfos damagesToDeal;
}
