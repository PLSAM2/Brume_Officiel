
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModuleProjectileSpell : SpellModule
{
    [SerializeField] Sc_ProjectileSpell spellParameters;

	public override void ResolveSpell (Vector3 mousePosition)
	{
		base.ResolveSpell(mousePosition);

	}
}
