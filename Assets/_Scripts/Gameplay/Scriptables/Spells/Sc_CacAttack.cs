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
	public float maxTimeCanalised { get => totalTime(); set { return; } }

	float totalTime()
	{
		float _temp=0;
		foreach(CacAttackParameters _attack in listOfAttacks)
		{
			_temp += _attack._timeToHoldToGetToNext;
		}
		return _temp;
	}
}


[System.Serializable]
public class CacAttackParameters
{
	[Header("hit Part")]
	[Tooltip("90")] public float angleToAttackFrom = 90;
	public float rangeOfTheAttackMin = 3, rangeOfTheAttackMax = 5;

	[Header("Enchainement")]
	public Sc_ForcedMovement movementOfTheCharacter, movementOfHit;
	public float _timeToHoldToGetToNext = .5f, _timeToHoldMax = .3f, _timeToForceResolve;

	//public float delayWithNextAttack=.3f;

	[Header("damage Part")]
	public DamagesInfos damagesToDeal;
}
