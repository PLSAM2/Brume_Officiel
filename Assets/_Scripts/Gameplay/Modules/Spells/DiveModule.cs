using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiveModule : SpellModule
{
	Sc_EffectAtEnd localTrad;

	private void Awake ()
	{
		localTrad = spell as Sc_EffectAtEnd;
	}

	public override void Interrupt ()
	{
		base.Interrupt();
		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.objectToSpawnAtThenEnd), transform.position, Vector3.zero);
	}
}
