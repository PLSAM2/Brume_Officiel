using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;
	[ReadOnly] public float Cooldown { get => _cooldown; set {
			_cooldown = value; UiManager.instance.UpdateUiCooldownSpell(actionLinked, _cooldown, spell.cooldown);
		} }
	float _cooldown = 0;
	[ReadOnly] public bool isUsed = false;
	public Sc_Spell spell;

	public En_SpellInput actionLinked;
	public Action<float> cooldownUpdatefirstSpell;
	[HideInInspector] public Vector3 recordedMousePosOnInput;
	[HideInInspector] public PlayerModule myPlayerModule;
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
		UiManager.instance.SetupIcon(spell, actionLinked);
		timeToResolveSpell = spell.canalisationTime;
	}

	public virtual void  OnDisable ()
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
	}

	public 	virtual void  Update ()
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
				Interrupt();
			}
		}
		else
			DecreaseCooldown();
	}

	public virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		canalisationParticle.Play();
		recordedMousePosOnInput = _BaseMousePos;
		myPlayerModule.state |= En_CharacterState.Canalysing;
		if (canBeCast())
		{
			startCanalisation?.Invoke();
			Cooldown = spell.cooldown;
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
		canalisationParticle.Stop();
		myPlayerModule.state = myPlayerModule.state & (myPlayerModule.state & ~(En_CharacterState.Canalysing));
		endCanalisation?.Invoke();
	}

	public void DecreaseCooldown ()
	{
		if (Cooldown >= 0)
			Cooldown -= Time.deltaTime;
	}

	bool canBeCast ()
	{
		if (/*(myPlayerModule.state | spell.StateAutorised) != spell.StateAutorised &&*/
			Cooldown>0 || isUsed)
			return false;
		else
			return true;
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