using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	En_CharacterState stateAtStart;

	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;
	protected bool isOwner;

	[ReadOnly]
	public float Cooldown
	{
		get => _cooldown; set
		{
			_cooldown = value;
			if (myPlayerModule.mylocalPlayer.isOwner)
			{
				UiManager.Instance.UpdateUiCooldownSpell(actionLinked, _cooldown, spell.cooldown);
			}
		}
	}
	private int _charges;

	[ReadOnly]
	public int charges
	{
		get => _charges;
		set
		{
			_charges = value;
			if (myPlayerModule.mylocalPlayer.isOwner)
			{
				UiManager.Instance.UpdateChargesUi(charges, actionLinked);
			}
			Cooldown = spell.cooldown;
		}
	}

	float _cooldown = 0;
	[ReadOnly] public bool isUsed = false, resolved;
	public Sc_Spell spell;

	public En_SpellInput actionLinked;
	public Action<float> cooldownUpdatefirstSpell;
	[ReadOnly] public Vector3 recordedMousePosOnInput;
	[ReadOnly] public PlayerModule myPlayerModule;
	public Action startCanalisation, endCanalisation;
	public ParticleSystem canalisationParticle;

	public virtual void SetupComponent ()
	{
		myPlayerModule = GetComponent<PlayerModule>();

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			if (myPlayerModule.mylocalPlayer.isOwner)
				isOwner = true;

			switch (actionLinked)
			{
				case En_SpellInput.FirstSpell:
					myPlayerModule.firstSpellInput += StartCanalysing;
					break;
				case En_SpellInput.SecondSpell:
					myPlayerModule.secondSpellInput += StartCanalysing;
					break;
				case En_SpellInput.ThirdSpell:
					myPlayerModule.thirdSpellInput += StartCanalysing;
					break;
				case En_SpellInput.Click:
					myPlayerModule.leftClickInput += StartCanalysing;
					break;
				case En_SpellInput.Ward:
					myPlayerModule.wardInput += StartCanalysing;
					break;
			}
			UiManager.Instance.SetupIcon(spell, actionLinked);
			timeToResolveSpell = spell.canalisationTime;

			startCanalisation += StartCanalysingFeedBack;
			endCanalisation += ResolveSpellFeedback;

			charges = spell.numberOfCharge;

			myPlayerModule.upgradeKit += UpgradeSpell;
			myPlayerModule.backToNormalKit += ReturnToNormal;
		}

	}

	protected virtual void OnDisable ()
	{
		if (isOwner)
		{
			switch (actionLinked)
			{
				case En_SpellInput.FirstSpell:
					myPlayerModule.firstSpellInput -= StartCanalysing;
					break;
				case En_SpellInput.SecondSpell:
					myPlayerModule.secondSpellInput -= StartCanalysing;
					break;
				case En_SpellInput.ThirdSpell:
					myPlayerModule.thirdSpellInput -= StartCanalysing;
					break;
				case En_SpellInput.Click:
					myPlayerModule.leftClickInput -= StartCanalysing;
					break;
				case En_SpellInput.Ward:
					myPlayerModule.wardInput -= StartCanalysing;
					break;
			}
			startCanalisation -= StartCanalysingFeedBack;
			endCanalisation -= ResolveSpellFeedback;

			myPlayerModule.upgradeKit -= UpgradeSpell;
			myPlayerModule.backToNormalKit -= ReturnToNormal;
		}
	}

	protected virtual void Update ()
	{
		if (isUsed && !resolved)
		{
			currentTimeCanalised += Time.deltaTime;

			if (currentTimeCanalised >= timeToResolveSpell)
			{
				if (spell.useLastRecordedMousePos)
					ResolveSpell(recordedMousePosOnInput);
				else
					ResolveSpell(myPlayerModule.mousePos());
			}
		}
		else
			DecreaseCooldown();
	}

	protected virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		resolved = false;

		if (canBeCast())
		{
			stateAtStart = myPlayerModule.state;

			if (charges == spell.numberOfCharge)
				Cooldown = spell.cooldown;

			charges -= 1;

			recordedMousePosOnInput = _BaseMousePos;
			myPlayerModule.AddState(En_CharacterState.Canalysing);
			startCanalisation?.Invoke();

			isUsed = true;
		}
	}

	public virtual void Interrupt ()
	{
		isUsed = false;
		currentTimeCanalised = 0;
		TreatCharacterState();
	}

	protected virtual void ResolveSpell ( Vector3 _mousePosition )
	{
		endCanalisation?.Invoke();
		resolved = true;
		Interrupt();
	}

	protected virtual void TreatCharacterState ()
	{
		if ((stateAtStart & En_CharacterState.Canalysing) == 0)
			myPlayerModule.RemoveState(En_CharacterState.Canalysing);
	}

	public virtual void DecreaseCooldown ()
	{
		if (charges < spell.numberOfCharge)
		{
			if (Cooldown >= 0)
				Cooldown -= Time.deltaTime;
			else
			{
				charges += 1;
			}
		}
	}

	protected virtual void UpgradeSpell ( Sc_UpgradeSpell _rule ) { }


	protected virtual void ReturnToNormal () { }


	public void ReduceCooldown ( float _durationShorten )
	{
		Cooldown -= _durationShorten;
	}

	bool canBeCast ()
	{
		if ((myPlayerModule.state & spell.forbiddenState) != 0 ||
			charges == 0 || isUsed)
			return false;
		else
			return true;
	}


	void StartCanalysingFeedBack ()
	{
		myPlayerModule.mylocalPlayer.triggerAnim.Invoke("Canalyse");
	}
	void ResolveSpellFeedback ()
	{
		myPlayerModule.mylocalPlayer.triggerAnim.Invoke("Resolve");
	}

	public void StartParticleCanalisation ()
	{
		canalisationParticle.Play();

	}
	public void StopParticleCanalisation ()
	{
		canalisationParticle.Stop();
	}
}

public enum En_SpellInput
{
	FirstSpell,
	SecondSpell,
	ThirdSpell,
	Click,
	Maj,
	Ward
}