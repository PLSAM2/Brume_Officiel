using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;

public class UpgradeModule : SpellModule
{
	float bonusTimeRemaining;
	float durationThrowback;
	bool throwbackTriggered, canTakeThrowBack = false;
	Sc_UpgradeSpell _tempSpellTrad;

	void Start ()
	{
		_tempSpellTrad = spell as Sc_UpgradeSpell;
	}
	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		base.ResolveSpell(_mousePosition);
		MovementModifier _tempModifier = new MovementModifier();

		_tempModifier.duration = _tempSpellTrad.duration;
		_tempModifier.percentageOfTheModifier = 1 + _tempSpellTrad.bonusPercentageMoveSpeed;
		myPlayerModule.addMovementModifier(_tempModifier);

		bonusTimeRemaining = _tempSpellTrad.duration;
		durationThrowback = _tempSpellTrad.durationSilenced;


		myPlayerModule.upgradeKit.Invoke(_tempSpellTrad);
		throwbackTriggered = false;
	}

	private void FixedUpdate ()
	{
		if (canTakeThrowBack)
		{
			if (bonusTimeRemaining > 0)
			{
				bonusTimeRemaining -= Time.fixedDeltaTime;
			}
			else if (!throwbackTriggered)
			{
				EndBonusCallBack();
			}
		}


		if (durationThrowback > 0)
		{
			durationThrowback -= Time.fixedDeltaTime;
		}
		else if (throwbackTriggered)
			EndMalusCallBack();

	}

	public override void Interrupt ()
	{
		currentTimeCanalised = 0;
		TreatCharacterState();
	}

	void EndBonusCallBack ()
	{
		myPlayerModule.backToNormalKit.Invoke();

		isUsed = false;
		
		canTakeThrowBack = true;
	}

	void StartThrowBack()
	{
		durationThrowback = _tempSpellTrad.durationSilenced;
		myPlayerModule.AddState(_tempSpellTrad.stateThrowbackToApply);
	}

	void EndMalusCallBack ()
	{
		myPlayerModule.RemoveState(_tempSpellTrad.stateThrowbackToApply);
		canTakeThrowBack = false;
	}
}
