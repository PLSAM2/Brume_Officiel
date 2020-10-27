using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultipleProjectile : ModuleProjectileSpell
{
	protected override void ReadSalve ( Vector3 _posToSet, Vector3 _rot )
	{
		float _baseAngle = transform.forward.y - spellProj.angleToSplit / 2;
		float _angleToAdd = spellProj.angleToSplit / spellProj.numberOfProjShoot;

		for (int i= 0; i < spellProj.numberOfProjShoot; i++)
		{
			Vector3 _PosToSpawn = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;

			ShootProjectile(transform.position + _PosToSpawn, transform.rotation.eulerAngles + new Vector3(0, _baseAngle,0));
			_baseAngle += _angleToAdd;
		}
	}

	Vector3 Aim(Vector3 _PosToAimFor)
	{

		_PosToAimFor.y = transform.position.y;

		Vector3 _aim = _PosToAimFor - transform.position;

		float rotY = Mathf.Atan2(_aim.x, _aim.z) * Mathf.Rad2Deg;

		return Quaternion.Euler(90, rotY, 0).eulerAngles;
	}
}
