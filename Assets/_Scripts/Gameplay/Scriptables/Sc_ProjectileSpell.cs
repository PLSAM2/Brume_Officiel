using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/ShootSpell")]
public class Sc_ProjectileSpell : Sc_Spell
{
	public St_ProjectileInfos projParameters;
	public int numberOfProjectileShotPerSalve= 4;
	public float timeToReachMaxRange = 1,  delayBetweenShot =.1f;

	public Projectile prefab;

	[Button]
	void SetupPrefab ()
	{
		prefab.myInfos.myDamages.damageHealth = projParameters.myDamages.damageHealth;

		prefab.myInfos.myLifeTime = range/ timeToReachMaxRange;
	}
}
