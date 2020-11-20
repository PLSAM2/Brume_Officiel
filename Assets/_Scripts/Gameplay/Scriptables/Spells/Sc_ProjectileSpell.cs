using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System.Runtime.InteropServices;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/ShootSpell")]
public class Sc_ProjectileSpell : Sc_Spell
{

	[Header("ProjectileParameters")]
	public DamagesInfos damagesToDeal;


	[Header("Projectile Prefabs")]
	public Projectile prefab;
	public Sc_ForcedMovement onHitForcedMovementToApply = null;
	public bool _reduceCooldowns = false;


	[Header("SalveInfos")]
	public float offSet = .1f;
	public SalveInfos salveInfos;



	[Header("MultiProjectile")]
	[SerializeField] bool isMultiple = false;

	[Min(1)] [ShowIf("isMultiple")] public int angleToSplit;

	[Header("UpgradePart")]
	[ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public float cooldownReduction = 0;
	[ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public int bonusShot;
	[ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public int bonusSalve;
	[ShowIf("_reduceCooldowns")] [VerticalGroup("Group2")] public float durationAdded;
}

[System.Serializable]
public struct SalveInfos
{
	[Min(1)] public int NumberOfSalve;
	[Min(1)] public int numberOfShotInSalve;
	public float timeToReachMaxRange, timeToResolveTheSalve;
}
