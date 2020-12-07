using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CounterBaseModule : SpellModule
{

	Sc_Counter localTrad;

	private void Awake ()
	{
		localTrad = (Sc_Counter)spell;
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		myPlayerModule.hitCountered += Counter;
		myPlayerModule.AddState(En_CharacterState.Countering);
	}

	public override void Interrupt ()
	{
		myPlayerModule.RemoveState(En_CharacterState.Countering);
		myPlayerModule.hitCountered -= Counter;
		base.Interrupt();
	}

	protected virtual void Counter(LocalPlayer playerCountered)
	{
		playerCountered.DealDamages(localTrad.damagesToDealer, transform.position);

		foreach (Sc_Status _status in localTrad.StatusToApplyToSelf)
			myPlayerModule.AddStatus(_status.effect);
	}
}
