using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System.Runtime.InteropServices;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/ShootSpell")]
public class Sc_ProjectileSpell : Sc_Spell
{
	public St_ProjectileInfos projParameters;
	public int numberOfProjectileShotPerSalve= 4;
	public float timeToReachMaxRange = 1,  delayBetweenShot =.1f;

	public Projectile prefabBlueTeam, prefabRedTeam;

	[Button]
	void SetupPrefab ()
	{

		prefabBlueTeam.myInfos.myDamages.damageHealth = projParameters.myDamages.damageHealth;
		prefabBlueTeam.myInfos.mySpeed = range / timeToReachMaxRange;
		prefabBlueTeam.myInfos.myLifeTime = timeToReachMaxRange;
		prefabRedTeam.myInfos.myDamages.damageHealth = projParameters.myDamages.damageHealth;
		prefabRedTeam.myInfos.mySpeed = range/ timeToReachMaxRange;
		prefabRedTeam.myInfos.myLifeTime = timeToReachMaxRange;

	

	}
}
