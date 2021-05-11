using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
public class CounterBaseModule : SpellModule
{

	public SpellModule spellToLaunchOnCounter;
	public En_SpellInput spellToReduceCooldown = En_SpellInput.Click;
	public float cooldownReduced= 1.5f;
	bool hasCounter = false;
	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		spellToLaunchOnCounter.SetupComponent(En_SpellInput.Special);
	}

	public override void TryCanalysing ( Vector3 _BaseMousePos )
	{
		base.TryCanalysing(_BaseMousePos);
		hasCounter = false;
	}

	protected override void AnonceSpell ( Vector3 _toAnnounce )
	{
		base.AnonceSpell(_toAnnounce);

	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		myPlayerModule.hitCountered += Counter;
		//myPlayerModule.AddState(En_CharacterState.Countering);

	}

	protected virtual void Counter ()
	{
		hasCounter = true;
		spellToLaunchOnCounter.ForceCanalyse(myPlayerModule.mousePos());
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Counter");
		myPlayerModule.reduceTargetCooldown(cooldownReduced, spellToReduceCooldown);

		Interrupt();
	}

	public override void Interrupt ( bool isInterrupted = false )
	{
		base.Interrupt();
		myPlayerModule.hitCountered -= Counter;
		// myPlayerModule.RemoveState(En_CharacterState.Countering);
	}

	protected override void ApplyEffectAtTheEnd ()
	{
		if (!hasCounter)
			base.ApplyEffectAtTheEnd();
	}
}
