using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FixedDistanceAoe : SpellModule
{
	public Aoe aoeInstantiated;

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		Vector3 posToInstantiate = Vector3.zero;

		if (aoeInstantiated.localTrad.rules.isBox)
			posToInstantiate = transform.position + transform.forward * aoeInstantiated.localTrad.rules.boxDimension.z/2;
		else
			posToInstantiate =  transform.position + transform.forward *  aoeInstantiated.localTrad.rules.aoeRadius;

		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeInstantiated.gameObject), posToInstantiate, transform.rotation.eulerAngles);
	}

}
