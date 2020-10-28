
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class ModuleProjectileSpell : SpellModule
{
	protected Sc_ProjectileSpell spellProj; //plus facile a lire dans le script
	int shotRemainingInSalve;
	[SerializeField] ushort indexOfTheShotProjectileBlue = 12, indexOfTheShotProjectileRed = 13;
	SalveInfos myLiveSalve;
	Vector3 lastForwardRecorded;

	bool shooting = false;
	float timeBetweenShot = 0;

	private void Start ()
	{
		spellProj = spell as Sc_ProjectileSpell;
		myLiveSalve = spellProj.salveInfos;

	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		base.StartCanalysing(_BaseMousePos);
		lastForwardRecorded = transform.forward + transform.position;
	}

	protected override void ResolveSpell ( Vector3 mousePosition )
	{
		shooting = true;
		shotRemainingInSalve = myLiveSalve.numberOfSalve;
		endCanalisation?.Invoke();
	}

	protected override void Update ()
	{
		base.Update();

		if (shooting == true)
		{
			isUsed = false;
			timeBetweenShot -= Time.deltaTime;
			if (timeBetweenShot <= 0)
			{
				//A RECORIGER POUR L INSTANT CA S EN FOUT
				if (spell.useLastRecordedMousePos)
					ShootSalve(PosToInstantiate(), RotationOfTheProj());
				else
					ShootSalve(PosToInstantiate(), RotationOfTheProj());
			}
		}
	}

	protected virtual Vector3 PosToInstantiate()
	{
		return transform.forward + transform.position;
	}

	protected virtual Vector3 RotationOfTheProj ()
	{
		return transform.rotation.eulerAngles;
	}


	void ShootSalve ( Vector3 _posToSet, Vector3 _rot )
	{
		timeBetweenShot = myLiveSalve.timeToResolveTheSalve / myLiveSalve.numberOfSalve;

		shotRemainingInSalve--;

		if (shotRemainingInSalve <= 0)
			Interrupt();

		ReadSalve();
	}

	protected void ReadSalve ()
	{
		float _baseAngle = transform.forward.y - spellProj.angleToSplit / 2;
		float _angleToAdd = spellProj.angleToSplit / spellProj.numberOfProjShoot;

		for (int i = 0; i < spellProj.numberOfProjShoot; i++)
		{
			Vector3 _PosToSpawn = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;

			ShootProjectile(transform.position + _PosToSpawn, transform.rotation.eulerAngles + new Vector3(0, _baseAngle, 0));
			_baseAngle += _angleToAdd;
		}
	}
	
	protected  void ShootProjectile ( Vector3 _posToSet, Vector3 _rot )
	{
		if (myPlayerModule.teamIndex == Team.blue)
			NetworkObjectsManager.Instance.NetworkInstantiate(indexOfTheShotProjectileBlue, _posToSet, _rot);
		else
			NetworkObjectsManager.Instance.NetworkInstantiate(indexOfTheShotProjectileRed, _posToSet, _rot);
	}


	public override void Interrupt ()
	{
		base.Interrupt();
		shooting = false;
	}

	protected override void UpgradeSpell ( Sc_UpgradeSpell _rule )
	{
		base.UpgradeSpell(_rule);
		myLiveSalve.timeToResolveTheSalve += _rule.durationAdded;
		myLiveSalve.numberOfSalve += _rule.shotAdded;
	}

	protected override void ReturnToNormal ()
	{
		base.ReturnToNormal();
		myLiveSalve = spellProj.salveInfos;
	}
}
