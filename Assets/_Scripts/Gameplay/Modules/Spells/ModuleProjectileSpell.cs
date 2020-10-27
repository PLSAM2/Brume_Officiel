
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class ModuleProjectileSpell : SpellModule
{
	Sc_ProjectileSpell spellProj; //plus facile a lire dans le script
	int shotRemainingInSalve;

	bool shooting = false;
	float timeBetweenShot;

	private void Start ()
	{
		spellProj = spell as Sc_ProjectileSpell;
	}

	protected override void ResolveSpell ( Vector3 mousePosition )
	{
		shooting = true;
		shotRemainingInSalve = spellProj.numberOfProjectileShotPerSalve;
		endCanalisation?.Invoke();
	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{
			_direction = Vector3.Normalize(recordedMousePosOnInput - transform.position);


		base.StartCanalysing(_BaseMousePos);
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
		timeBetweenShot = spellProj.delayBetweenShot;
		shotRemainingInSalve--;

		if (shotRemainingInSalve <= 0)
			Interrupt();

		ReadSalve(_posToSet, _rot);
	}

	protected virtual void ReadSalve ( Vector3 _posToSet, Vector3 _rot )
	{
		ShootProjectile(_posToSet, _rot);
	}

	void ShootProjectile ( Vector3 _posToSet, Vector3 _rot )
	{
		if (myPlayerModule.teamIndex == Team.blue)
			NetworkObjectsManager.Instance.NetworkInstantiate(12, _posToSet, _rot);
		else
			NetworkObjectsManager.Instance.NetworkInstantiate(13, _posToSet, _rot);
	}


	public override void Interrupt ()
	{
		base.Interrupt();
		shooting = false;
	}
}
