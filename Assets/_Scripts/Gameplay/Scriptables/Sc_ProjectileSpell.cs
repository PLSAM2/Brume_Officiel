using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System.Runtime.InteropServices;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/ShootSpell")]
public class Sc_ProjectileSpell : Sc_Spell
{
	public St_ProjectileInfos projParameters;
	public SalveInfos salveInfos;

	public Projectile prefabBlueTeam, prefabRedTeam;

	[SerializeField] bool isMultiple = false;
	[ShowIf("isMultiple")]
	public int numberOfProjShoot = 3;
	public int angleToSplit = 60;
}

[System.Serializable]
public class SalveInfos
{
	public int numberOfProjectileShotPerSalve = 4;
	public float timeToReachMaxRange = 1, timeToResolveTheSalve = .6f;
}
