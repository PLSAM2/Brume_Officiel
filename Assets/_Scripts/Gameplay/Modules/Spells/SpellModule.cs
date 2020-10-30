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
	public float cooldown
	{
		get => _cooldown; set
		{
			_cooldown = value;

			UiManager.Instance.UpdateUiCooldownSpell(actionLinked, _cooldown, finalCooldownValue());
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

			UiManager.Instance.UpdateChargesUi(charges, actionLinked);
			cooldown = finalCooldownValue();
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
	protected	Vector3 lastRecordedDirection = Vector3.zero;

	public virtual void SetupComponent ()
	{
		myPlayerModule = GetComponent<PlayerModule>();

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
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
		else
			Destroy(this);
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

		if (charges < spell.numberOfCharge && !isUsed)
			DecreaseCooldown();
	}

	protected virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if (canBeCast())
		{
			lastRecordedDirection = myPlayerModule.directionInputed();

			resolved = false;

			stateAtStart = myPlayerModule.state;

			if (charges == spell.numberOfCharge)
				cooldown = finalCooldownValue();

			charges -= 1;

			recordedMousePosOnInput = _BaseMousePos;
			myPlayerModule.AddState(En_CharacterState.Canalysing);
			startCanalisation?.Invoke();

			isUsed = true;
		}
		else
			return;
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
			if (cooldown >= 0)
				cooldown -= Time.deltaTime;
			else
			{
				charges += 1;
			}
		}
	}

	protected virtual void UpgradeSpell () { }

	protected virtual void ReturnToNormal () { }

	public void ReduceCooldown ( float _durationShorten )
	{
		cooldown -= _durationShorten;
	}

	protected virtual bool canBeCast ()
	{
		if ((myPlayerModule.state & spell.forbiddenState) != 0 ||
			charges == 0 || isUsed)
		{
			return false;
		}
		else
		{
			return true;
		}
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

	protected virtual float finalCooldownValue()
	{
		return spell.cooldown + spell.canalisationTime;
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