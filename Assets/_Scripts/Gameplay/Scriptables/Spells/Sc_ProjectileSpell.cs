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
	[TabGroup("ProjectileSpecifications")] public AnimationCurve _curveSpeed = AnimationCurve.Constant(0,1,1);


	[Header("SalveInfos")]
	[TabGroup("ProjectileSpecifications")] public float offSet = .1f;
	[TabGroup("ProjectileSpecifications")] public SalveInfos salveInfos;



	bool isMultiple => salveInfos.numberOfShotInSalve > 1;
	[Header("MultiProjectile")] [ShowIf("isMultiple")]
	[TabGroup("ProjectileSpecifications")] [Min(0)] public int angleToSplit;

	[Header("ImpactPArt")]

	[TabGroup("ProjectileSpecifications")] public ushort bouncingNumber;
	bool willBounce => bouncingNumber != 0;
	[TabGroup("ProjectileSpecifications")] [ShowIf("willBounce")] [Range(0, 1)] public float velocityKeptOnBounce = 1;
	[TabGroup("ProjectileSpecifications")] public bool diesOnPlayerTouch = true;
	[TabGroup("ProjectileSpecifications")] public bool diesOnWallTouch = false;

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
