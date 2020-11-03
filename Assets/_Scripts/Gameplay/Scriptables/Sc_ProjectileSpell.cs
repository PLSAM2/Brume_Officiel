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
	public float offSet = .1f;
	public SalveInfos salveInfos;
	


	[Header("MultiProjectile")]
	[SerializeField] bool isMultiple = false;

	[ShowIf("isMultiple")] public int angleToSplit;

	[Header("UpgradePart")]
	public int bonusShot;
	public int bonusSalve;
	public float durationAdded;
}

[System.Serializable]
public struct SalveInfos
{
	[Min(1)] public int numberOfSalve;
	[Min(1)] public int numberOfShot;
	public float timeToReachMaxRange, timeToResolveTheSalve;
}
