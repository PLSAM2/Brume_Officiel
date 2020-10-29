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

	public override void Interrupt ()
	{
		currentTimeCanalised = 0;
		TreatCharacterState();
	}

	void EndBonusCallBack ()
	{
		inBonus = false;
		myPlayerModule.backToNormalKit.Invoke();

		isUsed = false;

		StartThrowBack();
	}

	void StartThrowBack ()
	{
		print("MalusStart");
		throwbackTriggered = true;
		durationThrowback = _tempSpellTrad.durationSilenced;
		myPlayerModule.AddState(_tempSpellTrad.stateThrowbackToApply);
	}

	void EndMalusCallBack ()
	{
		print("Malusfinished");
		throwbackTriggered = false;
		myPlayerModule.RemoveState(_tempSpellTrad.stateThrowbackToApply);
	}
}
