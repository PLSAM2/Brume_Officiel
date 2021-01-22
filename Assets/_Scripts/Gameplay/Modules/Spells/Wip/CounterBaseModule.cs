using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CounterBaseModule : SpellModule
{

	public SpellModule spellToLaunchOnCounter;
	bool asCounter = false;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		spellToLaunchOnCounter.SetupComponent(En_SpellInput.Special);
	}

	protected override void AnonceSpell ( Vector3 _toAnnounce )
	{
		base.AnonceSpell(_toAnnounce);
		asCounter = false;
		myPlayerModule.hitCountered += Counter;
		myPlayerModule.AddState(En_CharacterState.Countering);
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		myPlayerModule.hitCountered -= Counter;
		myPlayerModule.RemoveState(En_CharacterState.Countering);
	}

	protected virtual void Counter()
	{
		spellToLaunchOnCounter.ForceCanalyse(myPlayerModule.mousePos());
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Counter");
		asCounter = true;
		ResolveSpell();
	}

	protected override void ApplyEffectAtTheEnd ()
	{
		if(!asCounter)
			base.ApplyEffectAtTheEnd();
	}
}
