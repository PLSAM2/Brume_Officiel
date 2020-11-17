using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	//int currentAttackToResolve = 0;
	CacAttackParameters attackToResolve;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);

		localTrad = (Sc_CacAttack)spell;

		switch (_actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.leftClickInputRealeased += StartCanalysing;
				break;

			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInputRealeased += StartCanalysing;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInputRealeased += StartCanalysing;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInputRealeased += StartCanalysing;
				break;
		}

		switch (_actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.leftClickInputRealeased += ResolveSpell;
				break;

			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInputRealeased += ResolveSpell;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInputRealeased += ResolveSpell;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInputRealeased += ResolveSpell;
				break;
		}
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		ResolveAttack();
	}

	void ResolveAttack ()
	{
		attackToResolve = localTrad.listOfAttacks[0];

		for(int i =0; i < localTrad.listOfAttacks.Count; i++)
		{
			if(currentTimeCanalised >= attackToResolve._timeToHoldMax)
			{
				currentTimeCanalised -= attackToResolve._timeToHoldMax;
			}
			else
				attackToResolve = localTrad.listOfAttacks[i];
		}

		myPlayerModule.forcedMovementInterrupted += ResolveSlash;

		//ptit dash tu connais
		if (attackToResolve.movementOfTheCharacter != null)
			myPlayerModule.movementPart.AddDash(attackToResolve.movementOfTheCharacter.MovementToApply(transform.forward, transform.position));
		else
			myPlayerModule.movementPart.AddDash(new ForcedMovement());
	}

	void ResolveSlash()
	{
		myPlayerModule.forcedMovementInterrupted -= ResolveSlash;

		CacAttackParameters _currentAttack = localTrad.listOfAttacks[0];

		List<GameObject> _listHit = new List<GameObject>();

		float _baseAngle = _currentAttack.angleToAttackFrom / 2 - _currentAttack.angleToAttackFrom;
		float _rangeOfTheAttack = _currentAttack.rangeOfTheAttackMin + (_currentAttack.rangeOfTheAttackMax - _currentAttack.rangeOfTheAttackMin) * Mathf.Clamp((currentTimeCanalised/ _currentAttack._timeToHoldMax),0,1);


		//RAYCAST POUR TOUCHER
		for (int i = 0; i < _currentAttack.angleToAttackFrom; i++)
		{
			Vector3 _direction = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;
			_baseAngle++;

			Ray _ray = new Ray( transform.position + Vector3.forward * .55f + Vector3.up * 1.2f, _direction);

			RaycastHit[] _allhits = Physics.RaycastAll(_ray, _rangeOfTheAttack, LayerMask.GetMask("Character"));
			Debug.DrawRay(_ray.origin, _ray.direction, Color.red, 5);

			//verif que le gameobject est pas deja dansa la liste
			for (int j = 0; j < _allhits.Length; j++)
			{
				if (!_listHit.Contains(_allhits[j].collider.gameObject))
				{
					_listHit.Add(_allhits[j].collider.gameObject);
				}
			}
		}
		//AU CAS OU JE ME TOUCHE COMME UN GRRRRRRRRRRRROS CON
		_listHit.Remove(gameObject);

		foreach (GameObject _go in _listHit)
		{
			LocalPlayer _playerTouched = _go.GetComponent<LocalPlayer>();

			_playerTouched.DealDamages(_currentAttack.damagesToDeal);

			//push
			if (_currentAttack.movementOfHit != null)
				_playerTouched.SendForcedMovement(_currentAttack.movementOfHit.MovementToApply(_playerTouched.transform.position, transform.position));
		}

		Interrupt();
		charges -= 1;
	}

	protected override void DecreaseCharge ()
	{
		return;
	}

}
