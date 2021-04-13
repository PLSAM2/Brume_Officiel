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
		myPlayerModule.mylocalPlayer.myUiPlayerManager.EnableBuff(true, "Overload");
		//GameManager.Instance.surchargeEffect.enabled = true;
	}

	protected  void FixedUpdate ()
	{
		if (inBonus)
		{
			if (bonusTimeRemaining > 0)
			{
				bonusTimeRemaining -= Time.fixedDeltaTime;
				myPlayerModule.mylocalPlayer.myUiPlayerManager.UpdateBuffDuration(bonusTimeRemaining/localTrad.duration);
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
		myPlayerModule.mylocalPlayer.myUiPlayerManager.EnableBuff(false, "Overload");

		myPlayerModule.backToNormalKit.Invoke();
		//GameManager.Instance.surchargeEffect.enabled = false;
		StartThrowBack();
	}

	void StartThrowBack ()
	{
		myPlayerModule.mylocalPlayer.SendStatus(localTrad.statusThrowback);
	}
}
