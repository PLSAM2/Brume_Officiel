using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
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
	protected Vector3 lastRecordedDirection = Vector3.zero;

	private void OnEnable ()
	{
		LocalPlayer.disableModule += Disable;
	}

	protected virtual void Disable ()
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

	public virtual void SetupComponent ( En_SpellInput _actionLinked )
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
			DestroyIfClient();
	}

	protected virtual void DestroyIfClient ()
	{
		Destroy(this);
	}


	protected virtual void FixedUpdate ()
	{
		if (isUsed && !resolved)
		{
			currentTimeCanalised += Time.fixedDeltaTime;
			TreatNormalCanalisation();
		}

		if (charges < spell.numberOfCharge && !isUsed)
			DecreaseCooldown();
	}

	protected virtual void TreatNormalCanalisation ()
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
			if (spell.canalysingStatus != null)
				spell.canalysingStatus.ApplyStatus(myPlayerModule.mylocalPlayer);

			lastRecordedDirection = myPlayerModule.directionInputed();

			resolved = false;

			DecreaseCharge();


			if (charges == spell.numberOfCharge)
				cooldown = finalCooldownValue();

			recordedMousePosOnInput = _BaseMousePos;

			startCanalisation?.Invoke();


			if (spell.lockRotOnCanalisation)
				myPlayerModule.rotationLock(true);


			isUsed = true;
		}
		else
			return;
	}

	protected virtual void DecreaseCharge ()
	{
		charges -= 1;
	}

	public virtual void Interrupt ()
	{
		isUsed = false;
		currentTimeCanalised = 0;
		endCanalisation?.Invoke();

		if (cooldown <= 0)
			cooldown = finalCooldownValue();

		if (spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(false);
	}


	protected virtual void ResolveSpell ( Vector3 _mousePosition )
	{
		resolved = true;
		Interrupt();
	}


	public virtual void DecreaseCooldown ()
	{
		if (charges < spell.numberOfCharge)
		{
			if (cooldown >= 0)
				cooldown -= Time.fixedDeltaTime;
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
		if (cooldown != finalCooldownValue())
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
		ApplyStatusCanalisation();
		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation0", true);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation1", true);
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation2", true);
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation3", true);
				break;
		}
	}

	protected virtual void ApplyStatusCanalisation()
	{
		Effect _newStatus = new Effect();
		_newStatus.finalLifeTime = spell.canalisationTime;
		if (spell.lockPosOnCanalisation)
			_newStatus.stateApplied = (En_CharacterState.Canalysing | En_CharacterState.Root);
		else
			_newStatus.stateApplied = En_CharacterState.Canalysing;

		myPlayerModule.AddStatus(_newStatus);
	}

	void ResolveSpellFeedback ()
	{
		//	myPlayerModule.mylocalPlayer.triggerAnim.Invoke("Resolve");
		if (spell.resolusionStatus != null)
			spell?.resolusionStatus.ApplyStatus(myPlayerModule.mylocalPlayer);

		if (particleResolution.Count > 0)
		{
			for (int i = 0; i < particleResolution.Count; i++)
			{
				particleResolution[i].Play();
			}
		}

		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation0", false);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation1", false);
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation2", false);
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation3", false);
				break;
		}
	}

	public void StartParticleCanalisation ()
	{
		canalisationParticle.Play();
	}

	protected virtual float durationOfTheMovementModifier ()
	{
		return spell.canalisationTime;
	}


	public void StopParticleCanalisation ()
	{
		canalisationParticle.Stop();
	}

	protected virtual float finalCooldownValue ()
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