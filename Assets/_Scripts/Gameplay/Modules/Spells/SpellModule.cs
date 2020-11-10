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
		}
	}

	float _cooldown = 0;
	[ReadOnly] public bool isUsed = false, resolved;
	public Sc_Spell spell;

	En_SpellInput actionLinked;
	public Action<float> cooldownUpdatefirstSpell;
	[ReadOnly] public Vector3 recordedMousePosOnInput;
	[ReadOnly] public PlayerModule myPlayerModule;
	public Action startCanalisation, endCanalisation;
	public ParticleSystem canalisationParticle;
	public List<ParticleSystem> particleResolution;
	protected	Vector3 lastRecordedDirection = Vector3.zero;

	private void OnEnable ()
	{
		LocalPlayer.disableModule += Disable;
	}
	
	protected virtual void Disable()
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

	public virtual void SetupComponent ( En_SpellInput _actionLinked)
	{
		myPlayerModule = GetComponent<PlayerModule>();

		actionLinked = _actionLinked;
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

	protected virtual void Update ()
	{
		if (isUsed && !resolved)
		{
			currentTimeCanalised += Time.deltaTime;

			TreatNormalCanalisation();
		}

		if (charges < spell.numberOfCharge && !isUsed)
			DecreaseCooldown();
	}

	protected virtual void TreatNormalCanalisation()
	{
		if (currentTimeCanalised >= timeToResolveSpell)
		{
			if (spell.useLastRecordedMousePos)
				ResolveSpell(recordedMousePosOnInput);
			else
				ResolveSpell(myPlayerModule.mousePos());
		}
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


			if (spell.lockOnCanalisation)
				myPlayerModule.rotationLock(true);


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

		if(cooldown<=0)
			cooldown = finalCooldownValue();
		
		if (spell.lockOnCanalisation)
			myPlayerModule.rotationLock(false);
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
				cooldown = finalCooldownValue();
			}
		}
	}

	protected virtual void UpgradeSpell () { }

	protected virtual void ReturnToNormal () { }

	public void ReduceCooldown ( float _durationShorten )
	{
		if(cooldown != finalCooldownValue())
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
		MovementModifier _temp = new MovementModifier();
		_temp.percentageOfTheModifier = spell.movementModifierDuringCanalysing;
		_temp.duration = durationOfTheMovementModifier();
		myPlayerModule.addMovementModifier(_temp);
		myPlayerModule.mylocalPlayer.triggerAnim.Invoke("Canalyse");
	}

	void ResolveSpellFeedback ()
	{
		myPlayerModule.mylocalPlayer.triggerAnim.Invoke("Resolve");

		if(particleResolution.Count > 0)
		{
			for (int i = 0; i < particleResolution.Count; i ++)
			{
				particleResolution[i].Play();
			}
		}
	}

	public void StartParticleCanalisation ()
	{
		canalisationParticle.Play();
	}

	protected virtual float durationOfTheMovementModifier()
	{
		return spell.canalisationTime; 
	}


	public void StopParticleCanalisation ()
	{
		canalisationParticle.Stop();
	}

	protected virtual float finalCooldownValue()
	{
		return spell.cooldown;
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