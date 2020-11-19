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
				myPlayerModule.leftClickInput += StartCanalysing;
				break;

			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += StartCanalysing;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += StartCanalysing;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += StartCanalysing;
				break;
		}

		switch (_actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.leftClickInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInputRealeased += ResolveAttack;
				break;
		}
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		return;
	}


	protected override void TreatNormalCanalisation ()
	{
		return;
	}
	protected override void DecreaseCharge ()
	{
		return;
	}

	protected override void ApplyStatusCanalisation ()
	{
		return;
	}


	void ResolveAttack ( Vector3 _mousePos )
	{
		if(isUsed)
		{ 
		attackToResolve = localTrad.listOfAttacks[0];

	/*	for (int i = 0; i < localTrad.listOfAttacks.Count; i++)
		{
			print(currentTimeCanalised);
			if (currentTimeCanalised >= attackToResolve._timeToHoldMax)
			{
				currentTimeCanalised -= attackToResolve._timeToHoldMax;
			}
			else
				attackToResolve = localTrad.listOfAttacks[i];
		}*/
		if(currentTimeCanalised >= localTrad.listOfAttacks[0]._timeToHoldMax)
			attackToResolve = localTrad.listOfAttacks[1];

		print(attackToResolve.angleToAttackFrom);
		//ptit dash tu connais
		if (attackToResolve.movementOfTheCharacter == null )
		{
			ResolveSlash();
		}
		else
		{
			myPlayerModule.forcedMovementInterrupted += ResolveSlash;
			if(spell.useLastRecordedMousePos)
				myPlayerModule.movementPart.AddDash(attackToResolve.movementOfTheCharacter.MovementToApply(transform.forward, transform.position));
			else
				myPlayerModule.movementPart.AddDash(attackToResolve.movementOfTheCharacter.MovementToApply(myPlayerModule.mousePos(), transform.position));

		}


	}

	void ResolveSlash ()
		{
			if (attackToResolve.movementOfTheCharacter != null)
			{
				myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
			}

			List<GameObject> _listHit = new List<GameObject>();

			float _baseAngle = attackToResolve.angleToAttackFrom / 2 - attackToResolve.angleToAttackFrom;
			float _rangeOfTheAttack = attackToResolve.rangeOfTheAttackMin + (attackToResolve.rangeOfTheAttackMax - attackToResolve.rangeOfTheAttackMin) * Mathf.Clamp((currentTimeCanalised / attackToResolve._timeToHoldMax), 0, 1);


			//RAYCAST POUR TOUCHER
			for (int i = 0; i < attackToResolve.angleToAttackFrom; i++)
			{
				Vector3 _direction = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;
				_baseAngle++;

				Ray _ray = new Ray(transform.position + Vector3.forward * .55f + Vector3.up * 1.2f, _direction);

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

				_playerTouched.DealDamages(attackToResolve.damagesToDeal);

				//push
				if (attackToResolve.movementOfHit != null)
					_playerTouched.SendForcedMovement(attackToResolve.movementOfHit.MovementToApply(_playerTouched.transform.position, transform.position));
			}

			Interrupt();
		}
	}
	public override void Interrupt ()
	{
		myPlayerModule.StopStatus(spell.canalysingStatus.effect.forcedKey);
		charges--;
		base.Interrupt();
	}
}
