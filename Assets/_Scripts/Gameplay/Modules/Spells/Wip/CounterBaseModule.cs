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

	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		base.StartCanalysing(_BaseMousePos);
		asCounter = false;
	}

	protected override void AnonceSpell ( Vector3 _toAnnounce )
	{
		base.AnonceSpell(_toAnnounce);
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
		asCounter = true;
		spellToLaunchOnCounter.ForceCanalyse(myPlayerModule.mousePos());
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Counter");
		ResolveSpell();
	}

	protected override void ApplyEffectAtTheEnd ()
	{
		if(!asCounter)
			base.ApplyEffectAtTheEnd();
	}
}
