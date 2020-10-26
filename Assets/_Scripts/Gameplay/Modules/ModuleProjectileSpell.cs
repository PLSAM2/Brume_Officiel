
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModuleProjectileSpell : SpellModule
{
	[SerializeField] Sc_ProjectileSpell spellParameters;
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
			timeBetweenShot -= Time.deltaTime;

			if (timeBetweenShot <= 0)
			{
				if (spell.useLastRecordedMousePos)
					ShootProjectile(Vector3.Normalize(_direction), transform.forward);
				else
					ShootProjectile(Vector3.Normalize(myPlayerModule.mousePos() - transform.position), transform.forward);

			}
		}
	}
	void ShootProjectile ( Vector3 _direction, Vector3 _posToSet )
	{
		timeBetweenShot = spellProj.delayBetweenShot;
		shotRemainingInSalve--;
		if (shotRemainingInSalve <= 0)
			shooting = false;
		//REZO A IMPLEMENTER
		//GameObject =  NetworkObjectsManager.Instance.NetworkInstantiate(12, _posToSet, transform.rotation.eulerAngles);
		Projectile _proj = Instantiate(spellProj.prefab, _posToSet, transform.rotation);
		_proj.myInfos.myDirection = _direction;

	}
}
