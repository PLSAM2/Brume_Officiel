using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System.Runtime.InteropServices;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/ShootSpell")]
public class Sc_ProjectileSpell : Sc_Spell
{

	[Header("ProjectileParameters")]
	public St_ProjectileInfos projParameters;


	[Header("Projectile Prefabs")]
	public Projectile prefabBlueTeam, prefabRedTeam;


	[Header("SalveInfos")]
	public SalveInfos salveInfos;


	[Header("MultiProjectile")]
	[SerializeField] bool isMultiple = false;

	[ShowIf("isMultiple")] [Min(1)] public int numberOfProjShoot = 3;
	[ShowIf("isMultiple")] public int angleToSplit;
}

[System.Serializable]
public struct SalveInfos
{
	[Min(1)] public int numberOfSalve;
	public float timeToReachMaxRange, timeToResolveTheSalve;
}
