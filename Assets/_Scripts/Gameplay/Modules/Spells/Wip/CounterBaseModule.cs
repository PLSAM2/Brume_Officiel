using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CounterBaseModule : SpellModule
{

	public SpellModule spellToLaunchOnCounter;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		spellToLaunchOnCounter.SetupComponent(En_SpellInput.Special);
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		myPlayerModule.hitCountered += Counter;
	}

	public override void Interrupt ()
	{
		base.Interrupt();
		myPlayerModule.hitCountered -= Counter;
	}

	protected virtual void Counter()
	{
		spellToLaunchOnCounter.StartCanalysing(myPlayerModule.mousePos());
		myPlayerModule.mylocalPlayer.triggerAnim("Counter"); 
		Interrupt();
	}
}
