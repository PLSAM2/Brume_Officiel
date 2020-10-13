﻿using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
public class UiManager : MonoBehaviour
{
	public static UiManager instance;
	public PlayerModule myPlayerModule;
	public IconUi firstSpell, secondSpell, thirdSpell, sprintIcon, autoAttackIcon;

	public TextMeshProUGUI timer;
	private void Awake ()
	{
		if (instance == null || instance == this)
			instance = this;
		else
			Destroy(this);
	}

	public void UpdateUiCooldownSpell (En_SpellInput spell, float _time, float _completeCd)
	{
		float _percentageRemaining = _time / _completeCd;

		switch (spell) 
		{
			case En_SpellInput.FirstSpell:
				firstSpell.UpdateFillAmount(_percentageRemaining);
				CheckBeReady(_time, _completeCd, firstSpell, .2f);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.UpdateFillAmount(_percentageRemaining);
				CheckBeReady(_time, _completeCd, secondSpell, .2f);
				break;

			case En_SpellInput.ThirdSpell:
				thirdSpell.UpdateFillAmount(_percentageRemaining);
				CheckBeReady(_time, _completeCd, thirdSpell, .2f);
				break;

			case En_SpellInput.Maj:
				sprintIcon.UpdateFillAmount(_percentageRemaining);
				break;

			case En_SpellInput.Click:
				autoAttackIcon.UpdateFillAmount(_percentageRemaining);
				CheckBeReady(_time, _completeCd, autoAttackIcon, 0.05f);
				break;
		}		
	}

	public void SetupIcon(Sc_Spell _spellAttached, En_SpellInput _input )
	{
		switch(_input)
		{
			case En_SpellInput.FirstSpell:
				firstSpell.SetSprite(_spellAttached.spellIcon);
				break;

			case En_SpellInput.SecondSpell:
				secondSpell.SetSprite(_spellAttached.spellIcon);
				break;

			case En_SpellInput.ThirdSpell:
				thirdSpell.SetSprite(_spellAttached.spellIcon);
				break;

			case En_SpellInput.Maj:
				break;

			case En_SpellInput.Click:
				autoAttackIcon.SetSprite(_spellAttached.spellIcon);
				break;
		}
	}

	void CheckBeReady(float _actualTime, float _completeCd, IconUi _iconToPrep, float _timeToCheckShow)
	{
		if (_actualTime <= 0.1f)
			_iconToPrep.BeReady(true, _timeToCheckShow);
		else if (_completeCd - _actualTime <= _timeToCheckShow)
			_iconToPrep.BeReady(false, _timeToCheckShow);
	}
}
