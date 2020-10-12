using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;
	[ReadOnly] public float Cooldown { get => _cooldown; set { UiManager.instance.UpdateUiCooldownSpell(actionLinked, _cooldown, spell.cooldown); } }
	float _cooldown = 0;
	[ReadOnly] bool isUsed = false;
	[SerializeField] Sc_Spell spell;

	public En_SpellInput actionLinked;
	public Action<float> cooldownUpdatefirstSpell;

	PlayerModule myPlayerModule;

    private void Start()
    {
		myPlayerModule = GetComponent<PlayerModule>();
	}

    public void SetupComponent()
	{
		switch(actionLinked)
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
	}

	void OnDisable()
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

	void Update()
	{
		if(isUsed)
		{
			currentTimeCanalised += Time.deltaTime;
			if (currentTimeCanalised >= timeToResolveSpell)
			{
			//	ResolveSpell();
			}
		}
	}

	public void StartCanalysing ( Vector3 _BaseMousePos)
	{

	}

	public void Interrupt ()
	{

	}
	public virtual void ResolveSpell(Vector3 mousePosition)
	{
		Interrupt();
		Cooldown = spell.cooldown;
	}

	public void DecreaseCooldown()
	{
		if (!isUsed)
			Cooldown -= Time.deltaTime;
	}


	bool canBeCast()
	{
		if ((myPlayerModule.state | spell.StateAutorised) != spell.StateAutorised && Cooldown < spell.cooldown)
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