using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	int currentAttackToResolve = 0;

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
				myPlayerModule.leftClickInputRealeased += StopCanalysing;
				break;

			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInputRealeased += StopCanalysing;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInputRealeased += StopCanalysing;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInputRealeased += StopCanalysing;
				break;
		}
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		base.ResolveSpell(_mousePosition);

		ResolveAttack();

		//	foreach()

	}

	void ResolveAttack ()
	{

		CacAttackParameters _currentAttack = localTrad.listOfAttacks[currentAttackToResolve];

		myPlayerModule.forcedMovementInterrupted += ResolveSlash;

		//ptit dash tu connais
		ForcedMovement _newForcedMovement = new ForcedMovement();
		_newForcedMovement.direction = transform.forward;
		_newForcedMovement.duration = _currentAttack.dashDuration;
		_newForcedMovement.strength = _currentAttack.distanceToDash / _newForcedMovement.duration;
		myPlayerModule.forcedMovementAdded(_newForcedMovement);

	
		currentAttackToResolve++;

		if (currentAttackToResolve > localTrad.listOfAttacks.Count - 1)
		{
			StopCanalysing(Vector3.zero);
		}
		else
			currentTimeCanalised = 0;
	}

	void ResolveSlash( )
	{
		myPlayerModule.forcedMovementInterrupted -= ResolveSlash;

		CacAttackParameters _currentAttack = localTrad.listOfAttacks[currentAttackToResolve];

		List<GameObject> _listHit = new List<GameObject>();

		float _baseAngle = _currentAttack.angleToAttackFrom / 2 - _currentAttack.angleToAttackFrom;

		//RAYCAST POUR TOUCHER
		for (int i = 0; i < _currentAttack.angleToAttackFrom; i++)
		{
			Vector3 _direction = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;
			_baseAngle++;

			Ray _ray = new Ray( transform.position + Vector3.forward * .55f + Vector3.up * 1.2f, _direction);

			RaycastHit[] _allhits = Physics.RaycastAll(_ray, _currentAttack.rangeOfTheAttack, LayerMask.GetMask("Character"));
			Debug.DrawRay(_ray.origin, _ray.direction, Color.red, 5);
		/*	RaycastHit _hit; 
			if(Physics.Raycast(_ray, out _hit, _currentAttack.rangeOfTheAttack, gameObject.layer))
			{
				if (_hit.collider.gameObject != null)
					print(_hit.collider.gameObject.name);

				Debug.DrawRay(transform.position + Vector3.forward * .55f + Vector3.up * 1.2f, _direction * _currentAttack.rangeOfTheAttack, Color.red, 10);

			}*/

			for (int j = 0; j < _allhits.Length; j++)
			{
				if (!_listHit.Contains(_allhits[j].collider.gameObject))
				{
					_listHit.Add(_allhits[j].collider.gameObject);
				}
			}
		}
		_listHit.Remove(gameObject);

		DamagesInfos _damageToDeal = new DamagesInfos();
		_damageToDeal.damageHealth = _currentAttack.damagesToDeal;

		foreach (GameObject _go in _listHit)
		{
			LocalPlayer _playerTouched = _go.GetComponent<LocalPlayer>();
			_playerTouched.DealDamages(_damageToDeal);

			Debug.Log(_go.name);

			ForcedMovement _movementTosend = new ForcedMovement();
			_movementTosend.duration = _currentAttack.bumpDuration;
			_movementTosend.strength = _currentAttack.bumpDistance / _currentAttack.bumpDuration;
			_movementTosend.direction = Vector3.Normalize(_go.transform.position - transform.position);

			_playerTouched.SendForcedMovement(_movementTosend);
		}

	}

	void StopCanalysing ( Vector3 _mousePos )
	{
		currentAttackToResolve = 0;
		charges -= 1;
		Interrupt();
	}

	protected override void DecreaseCharge ()
	{
		return;
	}

}
