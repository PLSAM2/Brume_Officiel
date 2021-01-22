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
		myPlayerModule.AddState(En_CharacterState.Countering);
	}

	public override void Interrupt ()
	{
		base.Interrupt();
		myPlayerModule.hitCountered -= Counter;
		myPlayerModule.RemoveState(En_CharacterState.Countering);

	}

	protected virtual void Counter()
	{
		spellToLaunchOnCounter.ForceCanalyse(myPlayerModule.mousePos());
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Counter");
		Interrupt();
	}
}
