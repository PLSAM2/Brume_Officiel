using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;
	[ReadOnly]
	public float Cooldown
	{
		get => _cooldown; set
		{
			_cooldown = value; UiManager.Instance.UpdateUiCooldownSpell(actionLinked, _cooldown, spell.cooldown);
		}
	}
	public int _charges;

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
	[ReadOnly] public bool isUsed = false;
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
		}
		UiManager.Instance.SetupIcon(spell, actionLinked);
		timeToResolveSpell = spell.canalisationTime;

		startCanalisation += StartCanalysingFeedBack;
		endCanalisation += ResolveSpellFeedback;

		charges = spell.numberOfCharge;
	}

	public virtual void OnDisable ()
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
		}
		startCanalisation -= StartCanalysingFeedBack;
		endCanalisation -= ResolveSpellFeedback;
	}

	public virtual void Update ()
	{
		if (isUsed)
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

	public virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if (canBeCast())
		{
			if (charges == spell.numberOfCharge)
				Cooldown = spell.cooldown;

			charges -= 1;

			recordedMousePosOnInput = _BaseMousePos;
			myPlayerModule.state |= En_CharacterState.Canalysing;

			startCanalisation?.Invoke();
		
			isUsed = true;

		
		}
	}

	public void Interrupt ()
	{
		isUsed = false;
		currentTimeCanalised = 0;
	}

	public virtual void ResolveSpell ( Vector3 _mousePosition )
	{
		myPlayerModule.state = myPlayerModule.state & (myPlayerModule.state & ~(En_CharacterState.Canalysing));
		endCanalisation?.Invoke();
		Interrupt();
	}

	public void DecreaseCooldown ()
	{
		if(charges <  spell.numberOfCharge)
		{
			if (Cooldown >= 0)
				Cooldown -= Time.deltaTime;
			else
			{
				charges += 1;
				Cooldown = spell.cooldown;
			}
		}
		

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
	Maj
}