
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

	bool shooting = false;
	float timeBetweenShot = 0;

	private void Start ()
	{
		spellProj = spell as Sc_ProjectileSpell;
		myLiveSalve = spellProj.salveInfos;
	}

	protected override void ResolveSpell ( Vector3 mousePosition )
	{
		shooting = true;
		shotRemainingInSalve = spellProj.salveInfos.numberOfProjectileShotPerSalve;
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
		timeBetweenShot = myLiveSalve.timeToResolveTheSalve / myLiveSalve.numberOfProjectileShotPerSalve;

		shotRemainingInSalve--;

		if (shotRemainingInSalve <= 0)
			Interrupt();

		ReadSalve(_posToSet, _rot);
	}

	protected virtual void ReadSalve ( Vector3 _posToSet, Vector3 _rot )
	{
		ShootProjectile(_posToSet, _rot);
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
}
