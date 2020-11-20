using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	//int currentAttackToResolve = 0;
	float maxTime;
	En_SpellInput input;

	ShapePreview shapePreview;

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

		ActionAdd();

		float finalMaxTime = 0;
		for (int i = 0; i < localTrad.listOfAttacks.Count; i++)
		{
			if (i == localTrad.listOfAttacks.Count - 1)
				finalMaxTime += localTrad.listOfAttacks[i]._timeToForceResolve + localTrad.listOfAttacks[i]._timeToHoldToGetToNext;
			else
				finalMaxTime += localTrad.listOfAttacks[i]._timeToHoldToGetToNext;

		}
		maxTime = finalMaxTime;

		startCanalisation += ActionAdd;
		endCanalisation += ActionClean;

		shapePreview = PreviewManager.Instance.GetShapePreview(this.transform);
		shapePreview.gameObject.SetActive(false);
	}

	protected override void Disable ()
	{
		base.Disable();

		startCanalisation -= ActionAdd;
		endCanalisation -= ActionClean;
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		return;
	}

	protected override void TreatNormalCanalisation ()
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
		}

		if (showingPreview)
		{
			InitPreview();
		}
	}

	protected override void InitPreview ()
	{
		base.InitPreview();
		float distanceOfTheDash = 0;
		if (AttackToResolve().movementOfTheCharacter != null)
			distanceOfTheDash = AttackToResolve().movementOfTheCharacter.movementToApply.length; 
		shapePreview.Init(rangeOfTheAttack(), baseAngle(), 0, transform.position + transform.forward * distanceOfTheDash );
	}

	CacAttackParameters AttackToResolve ()
	{
		float timeElasped = currentTimeCanalised - Time.fixedDeltaTime * 1.2f;

		for (int i = 0; i < localTrad.listOfAttacks.Count; i++)
		{
			if (timeElasped > localTrad.listOfAttacks[i]._timeToHoldToGetToNext)
			{
				timeElasped = localTrad.listOfAttacks[i]._timeToHoldToGetToNext;
			}
			else
				return localTrad.listOfAttacks[i];

			if (i == localTrad.listOfAttacks.Count - 1)
			{
				return localTrad.listOfAttacks[i];
			}

		}

		return localTrad.listOfAttacks[0];
	}
	float baseAngle ()
	{
		return AttackToResolve().angleToAttackFrom / 2 - AttackToResolve().angleToAttackFrom;
	}

	float rangeOfTheAttack ()
	{
		return AttackToResolve().rangeOfTheAttackMin + (AttackToResolve().rangeOfTheAttackMax - AttackToResolve().rangeOfTheAttackMin) * (currentTimeCanalised / AttackToResolve()._timeToHoldMax);
	}

	void ResolveAttack ( Vector3 _mousePos )
	{
		if (isUsed)
		{
			/*if (currentTimeCanalised >= localTrad.listOfAttacks[0]._timeToHoldMax)
				attackToResolve = localTrad.listOfAttacks[1];*/


			//ptit dash tu connais
			if (AttackToResolve().movementOfTheCharacter == null)
			{
				ResolveSlash();
			}
			else
			{
				myPlayerModule.forcedMovementInterrupted += ResolveSlash;

				if (spell.useLastRecordedMousePos)
					myPlayerModule.movementPart.AddDash(AttackToResolve().movementOfTheCharacter.MovementToApply(transform.forward, transform.position));
				else
					myPlayerModule.movementPart.AddDash(AttackToResolve().movementOfTheCharacter.MovementToApply(myPlayerModule.mousePos(), transform.position));

			}


		}
	}


	void ResolveSlash ()
	{
		if (AttackToResolve().movementOfTheCharacter != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
		}

		List<GameObject> _listHit = new List<GameObject>();

		float _angle = baseAngle();

		//RAYCAST POUR TOUCHER
		for (int i = 0; i < AttackToResolve().angleToAttackFrom; i++)
		{
			Vector3 _direction = Quaternion.Euler(0, _angle, 0) * transform.forward;
			_angle++;

			Ray _ray = new Ray(transform.position + Vector3.up * 1.2f, _direction);
			Ray _debugRay = new Ray(transform.position + Vector3.up * 1.2f, _direction);

			RaycastHit[] _allhits = Physics.RaycastAll(_ray, rangeOfTheAttack(), 1 << 8);

			Debug.DrawRay(_ray.origin, _debugRay.direction * rangeOfTheAttack(), Color.red, 5);

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

			_playerTouched.DealDamages(AttackToResolve().damagesToDeal);

			//push
			if (AttackToResolve().movementOfHit != null)
				_playerTouched.SendForcedMovement(AttackToResolve().movementOfHit.MovementToApply(_playerTouched.transform.position, transform.position));
		}

		Interrupt();
	}
public override void Interrupt ()
{
	myPlayerModule.StopStatus(spell.canalysingStatus.effect.forcedKey);
	base.Interrupt();
}

void ActionAdd ()
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
void ActionClean ()
{
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
