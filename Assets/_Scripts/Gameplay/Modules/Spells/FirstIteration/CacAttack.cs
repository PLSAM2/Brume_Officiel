using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	//int currentAttackToResolve = 0;
	CacAttackParameters attackToResolve;
	float maxTime;

	En_SpellInput input;
	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		input = _actionLinked;

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

		float finalMaxTime = 0;
		for (int i = 0; i < localTrad.listOfAttacks.Count; i++)
		{
			if (i == localTrad.listOfAttacks.Count - 1)
				finalMaxTime += localTrad.listOfAttacks[i]._timeToForceResolve+ localTrad.listOfAttacks[i]._timeToHoldToGetToNext;
			else
				finalMaxTime += localTrad.listOfAttacks[i]._timeToHoldToGetToNext;
	
		}
		maxTime = finalMaxTime;
	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		base.StartCanalysing(_BaseMousePos);
		if (canBeCast())
		{
			switch (input)
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

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		if (currentTimeCanalised >= maxTime)
		{
			ResolveAttack(myPlayerModule.mousePos());

			switch (input)
			{
				case En_SpellInput.Click:
					myPlayerModule.leftClickInputRealeased -= ResolveAttack;
					break;

				case En_SpellInput.FirstSpell:
					myPlayerModule.firstSpellInputRealeased -= ResolveAttack;
					break;

				case En_SpellInput.SecondSpell:
					myPlayerModule.secondSpellInputRealeased -= ResolveAttack;
					break;

				case En_SpellInput.ThirdSpell:
					myPlayerModule.thirdSpellInputRealeased -= ResolveAttack;
					break;
			}
		}
	}

	void ResolveAttack ( Vector3 _mousePos )
	{
		if (isUsed)
		{
			currentTimeCanalised -= Time.fixedDeltaTime * 2;

			for (int i = 0; i < localTrad.listOfAttacks.Count; i++)
			{
				if (currentTimeCanalised > localTrad.listOfAttacks[i]._timeToHoldToGetToNext)
				{
					currentTimeCanalised -= localTrad.listOfAttacks[i]._timeToHoldToGetToNext;
				}
				else
					attackToResolve = localTrad.listOfAttacks[i];


				if (i == localTrad.listOfAttacks.Count-1)
				{
					attackToResolve = localTrad.listOfAttacks[i];
				}
			}

			/*if (currentTimeCanalised >= localTrad.listOfAttacks[0]._timeToHoldMax)
				attackToResolve = localTrad.listOfAttacks[1];*/


			//ptit dash tu connais
			if (attackToResolve.movementOfTheCharacter == null)
			{
				ResolveSlash();
			}
			else
			{
				myPlayerModule.forcedMovementInterrupted += ResolveSlash;
				if (spell.useLastRecordedMousePos)
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
			float _rangeOfTheAttack = attackToResolve.rangeOfTheAttackMin + (attackToResolve.rangeOfTheAttackMax - attackToResolve.rangeOfTheAttackMin) * (currentTimeCanalised / attackToResolve._timeToHoldMax);
			print(_rangeOfTheAttack);
			print( attackToResolve._timeToHoldMax);


			//RAYCAST POUR TOUCHER
			for (int i = 0; i < attackToResolve.angleToAttackFrom; i++)
			{
				Vector3 _direction = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;
				_baseAngle++;

				Ray _ray = new Ray(transform.position + Vector3.up * 1.2f, _direction);
				Ray _debugRay = new Ray(transform.position + Vector3.up * 1.2f, _direction);

				RaycastHit[] _allhits = Physics.RaycastAll(_ray, _rangeOfTheAttack, 1<<8);
			
				Debug.DrawRay(_ray.origin, _debugRay.direction * _rangeOfTheAttack, Color.red, 5);

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
