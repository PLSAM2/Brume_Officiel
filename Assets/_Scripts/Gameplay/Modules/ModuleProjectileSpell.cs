
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class ModuleProjectileSpell : SpellModule
{
	Sc_ProjectileSpell spellProj; //plus facile a lire dans le script
	Vector3 _direction;
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
					ShootProjectile(transform.forward + transform.position);
				else
					ShootProjectile(transform.forward + transform.position);
			}
		}
	}
	void ShootProjectile ( Vector3 _posToSet )
	{
		timeBetweenShot = spellProj.delayBetweenShot;
		shotRemainingInSalve--;
		if (shotRemainingInSalve <= 0)
			Interrupt();


		if(myPlayerModule.teamIndex == Team.blue)
			NetworkObjectsManager.Instance.NetworkInstantiate(12, _posToSet, transform.rotation.eulerAngles);
		else
			NetworkObjectsManager.Instance.NetworkInstantiate(13, _posToSet, transform.rotation.eulerAngles);
	}

	public override void Interrupt ()
	{
		base.Interrupt();
		shooting = false;
	}
}
