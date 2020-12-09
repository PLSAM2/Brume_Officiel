using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CounterBaseModule : SpellModule
{

	Sc_Counter localTrad;
	public SpellModule spellToLaunchOnCounter;

	private void Awake ()
	{
		localTrad = (Sc_Counter)spell;
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		myPlayerModule.hitCountered += Counter;
	}

	public override void Interrupt ()
	{
		myPlayerModule.hitCountered -= Counter;
		base.Interrupt();
	}

	protected virtual void Counter(LocalPlayer playerCountered)
	{
		foreach (Sc_Status _status in localTrad.StatusToApplyToSelf)
			myPlayerModule.AddStatus(_status.effect);

		spellToLaunchOnCounter.StartCanalysing(myPlayerModule.mousePos());
	}
}
