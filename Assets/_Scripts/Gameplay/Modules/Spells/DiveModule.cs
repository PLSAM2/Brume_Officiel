using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiveModule : SpellModule
{
	Sc_EffectAtEnd localTrad;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		localTrad = spell as Sc_EffectAtEnd;
	}
	protected override void ResolveSpell ()
	{
		myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("Diving", true);
		myPlayerModule.mylocalPlayer.EnableBuff(true, "Diving");

		/*
		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += ForceInterrupt;
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += ForceInterrupt;
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += ForceInterrupt;
				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += ForceInterrupt;
				break;
			case En_SpellInput.Ward:
				myPlayerModule.wardInput += ForceInterrupt;
				break;
		}*/
		myPlayerModule.firstSpellInput += ForceInterrupt;
		myPlayerModule.secondSpellInput += ForceInterrupt;
		myPlayerModule.thirdSpellInput += ForceInterrupt;
		myPlayerModule.leftClickInput += ForceInterrupt;
		myPlayerModule.wardInput += ForceInterrupt;


		base.ResolveSpell();
	}
	public override void Interrupt ()
	{
		myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("Diving", false);
		myPlayerModule.mylocalPlayer.EnableBuff(false, "Diving");

		/*switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= ForceInterrupt;
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= ForceInterrupt;
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= ForceInterrupt;
				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= ForceInterrupt;
				break;
			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= ForceInterrupt;
				break;
		}*/
		base.Interrupt();

		myPlayerModule.firstSpellInput -= ForceInterrupt;
		myPlayerModule.secondSpellInput -= ForceInterrupt;
		myPlayerModule.thirdSpellInput -= ForceInterrupt;
		myPlayerModule.leftClickInput -= ForceInterrupt;
		myPlayerModule.wardInput -= ForceInterrupt;

		StartCoroutine(WaitDelay());
	//	NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.objectToSpawnAtThenEnd), transform.position, Vector3.zero);
	}

	protected override void TreatThrowBack ()
	{
		base.TreatThrowBack();

		if (resolved && throwbackTime <= spell.throwBackDuration && isUsed)
		{
			myPlayerModule.mylocalPlayer.UpdateBuffDuration(throwbackTime / spell.throwBackDuration);
		}
	}

	void ForceInterrupt(Vector3 _temp)
	{
		Interrupt();
	}
	IEnumerator WaitDelay()
	{
		yield return new WaitForSeconds(localTrad.timeToWaitBeforeSpawning);
		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.objectToSpawnAtThenEnd), transform.position, Vector3.zero);
	}
}
