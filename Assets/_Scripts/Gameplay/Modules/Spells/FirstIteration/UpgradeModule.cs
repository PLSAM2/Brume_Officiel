using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;

public class UpgradeModule : SpellModule
{
	float bonusTimeRemaining ;
	bool throwbackTriggered = false;
	bool inBonus = false;
	Sc_UpgradeSpell localTrad;

	void Awake ()
	{
		localTrad = spell as Sc_UpgradeSpell;
	}

    protected override void ResolveSpell ( )
	{
		base.ResolveSpell();

		bonusTimeRemaining = localTrad.duration;
		myPlayerModule.upgradeKit.Invoke();
		inBonus = true;
		myPlayerModule.mylocalPlayer.EnableBuff(true, "Overload");
	}

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		if (inBonus)
		{
			if (bonusTimeRemaining > 0)
			{
				bonusTimeRemaining -= Time.fixedDeltaTime;
				myPlayerModule.mylocalPlayer.UpdateBuffDuration(bonusTimeRemaining/localTrad.duration);
			}
			else
			{
				EndBonusCallBack();
			}
		}

	}

	void EndBonusCallBack ()
	{
		inBonus = false;
		myPlayerModule.mylocalPlayer.EnableBuff(false, "Overload");

		myPlayerModule.backToNormalKit.Invoke();

		StartThrowBack();
	}

	void StartThrowBack ()
	{
		myPlayerModule.mylocalPlayer.SendStatus(localTrad.statusThrowback);
	}

	protected override float finalCooldownValue ()
	{
		float defValue = localTrad.duration + base.finalCooldownValue();
		return defValue;
	}
}
