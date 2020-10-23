
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModuleProjectileSpell : SpellModule
{
    [SerializeField] Sc_ProjectileSpell spellParameters;
	Sc_ProjectileSpell spellProj;
	bool shooting = false;

	private void Start ()
	{
		spellProj = spell as Sc_ProjectileSpell;
	}

	public override void ResolveSpell (Vector3 mousePosition)
	{
		shooting = true;
		endCanalisation?.Invoke();
	}

	void ShootProjectile(ProjectileInfos _ProjectileToShoot)
	{

	}
}
