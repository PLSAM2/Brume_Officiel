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
	protected override void ResolveSpell ()
	{
		myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("Diving", true);

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
		}
		base.ResolveSpell();
	}
	public override void Interrupt ()
	{
		myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("Diving", false);

		switch (actionLinked)
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
		}
		base.Interrupt();
		StartCoroutine(WaitDelay());
	//	NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.objectToSpawnAtThenEnd), transform.position, Vector3.zero);
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
