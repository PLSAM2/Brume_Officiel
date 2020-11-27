using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System.Runtime.InteropServices;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/ShootSpell")]
public class Sc_ProjectileSpell : Sc_Spell
{

	[Header("ProjectileParameters")]
	[TabGroup("ProjectileSpecifications")] public DamagesInfos damagesToDeal;


	[Header("Projectile Prefabs")]
	[TabGroup("ProjectileSpecifications")] public Projectile prefab;
	[TabGroup("ProjectileSpecifications")] public bool _reduceCooldowns = false;


	[Header("SalveInfos")]
	[TabGroup("ProjectileSpecifications")] public float offSet = .1f;
	[TabGroup("ProjectileSpecifications")] public SalveInfos salveInfos;



	[Header("MultiProjectile")]
	[TabGroup("ProjectileSpecifications")] [SerializeField] bool isMultiple = false;

	[TabGroup("ProjectileSpecifications")] [Min(1)] [ShowIf("isMultiple")] public int angleToSplit;

	[Header("UpgradePart")]
	[TabGroup("ProjectileSpecifications")] [ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public float cooldownReduction = 0;
	[TabGroup("ProjectileSpecifications")] [ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public int bonusShot;
	[TabGroup("ProjectileSpecifications")] [ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public int bonusSalve;
	[TabGroup("ProjectileSpecifications")] [ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public float durationAdded;
}

[System.Serializable]
public struct SalveInfos
{
	[Min(1)] public int NumberOfSalve;
	[Min(1)] public int numberOfShotInSalve;
	public float timeToReachMaxRange, timeToResolveTheSalve;
}
