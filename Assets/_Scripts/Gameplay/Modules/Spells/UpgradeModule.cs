using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;

public class UpgradeModule : SpellModule
{
	float bonusTimeRemaining ;
	float durationThrowback;
	bool throwbackTriggered = false;
	bool inBonus = false;
	Sc_UpgradeSpell _tempSpellTrad;

	void Awake ()
	{
		_tempSpellTrad = spell as Sc_UpgradeSpell;
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		base.ResolveSpell(_mousePosition);

		bonusTimeRemaining = _tempSpellTrad.duration;
		durationThrowback = _tempSpellTrad.durationSilenced;


		myPlayerModule.upgradeKit.Invoke();
		throwbackTriggered = false;

		inBonus = true;
	}

	protected override void Update ()
	{
		base.Update();

		if (inBonus)
		{
			if (bonusTimeRemaining > 0)
			{
				bonusTimeRemaining -= Time.deltaTime;
			}
			else
			{
				EndBonusCallBack();
			}
		}


		if(throwbackTriggered)
		{
			if (durationThrowback > 0)
			{
				durationThrowback -= Time.deltaTime;
			}
			else 
				EndMalusCallBack();
		}
	

	}


	void EndBonusCallBack ()
	{
		inBonus = false;
		myPlayerModule.backToNormalKit.Invoke();


		StartThrowBack();
	}

	void StartThrowBack ()
	{
		throwbackTriggered = true;
		durationThrowback = _tempSpellTrad.durationSilenced;
	}

	void EndMalusCallBack ()
	{
		throwbackTriggered = false;
	}

	protected override float finalCooldownValue ()
	{
		float defValue = _tempSpellTrad.duration + base.finalCooldownValue();
		return defValue;
	}
}
