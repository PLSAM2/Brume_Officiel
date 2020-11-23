using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	ShapePreview shapePreview;

	private void Awake ()
	{
		localTrad = (Sc_CacAttack)spell;
	}

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		shapePreview = PreviewManager.Instance.GetShapePreview(this.transform);
		shapePreview.gameObject.SetActive(false);
	}

	protected override void LinkInput ( En_SpellInput _actionLinked )
	{
		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				//myPlayerModule.firstSpellInput += ShowPreview;
				myPlayerModule.firstSpellInput += StartCanalysing;
				myPlayerModule.firstSpellInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.SecondSpell:
				//myPlayerModule.secondSpellInput += ShowPreview;
				myPlayerModule.secondSpellInput += StartCanalysing;
				myPlayerModule.secondSpellInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.ThirdSpell:
				//myPlayerModule.thirdSpellInput += ShowPreview;
				myPlayerModule.thirdSpellInput += StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.Click:
				//myPlayerModule.leftClickInput += ShowPreview;
				myPlayerModule.leftClickInput += StartCanalysing;
				myPlayerModule.leftClickInputRealeased += ResolveAttack;
				break;

			case En_SpellInput.Ward:
				//myPlayerModule.wardInput += ShowPreview;
				myPlayerModule.wardInput += StartCanalysing;
				myPlayerModule.wardInputReleased += ResolveAttack;
				break;
		}
	}

	protected override void Disable ()
	{
		base.Disable();
	}

	protected override void DelinkInput ( En_SpellInput _actionLinked )
	{
		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				//myPlayerModule.firstSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInput -= StartCanalysing;
				myPlayerModule.firstSpellInputRealeased -= ResolveAttack;
				break;

			case En_SpellInput.SecondSpell:
				//myPlayerModule.secondSpellInput -= ShowPreview;
				myPlayerModule.secondSpellInput -= StartCanalysing;
				myPlayerModule.secondSpellInputRealeased -= ResolveAttack;
				break;

			case En_SpellInput.ThirdSpell:
			//	myPlayerModule.thirdSpellInput -= ShowPreview;
				myPlayerModule.thirdSpellInput -= StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased -= ResolveAttack;
				break;

			case En_SpellInput.Click:
			//	myPlayerModule.leftClickInput -= ShowPreview;
				myPlayerModule.leftClickInput -= StartCanalysing;
				myPlayerModule.leftClickInputRealeased -= ResolveAttack;
				break;

			case En_SpellInput.Ward:
			//	myPlayerModule.wardInput -= ShowPreview;
				myPlayerModule.wardInput -= StartCanalysing;
				myPlayerModule.wardInputReleased -= ResolveAttack;
				break;
		}
	}

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		/*if (currentTimeCanalised >= localTrad.timeToForceResolve)
		{
			ResolveAttack(myPlayerModule.mousePos());
		}
		*/
		if (showingPreview)
		{
			UpdatePreview();
		}
	}

	//PREVIEW
	protected override void UpdatePreview ()
	{
		base.UpdatePreview();

		float distanceOfTheDash = 0;

		if (AttackToResolve().movementOfTheCharacter != null)
			distanceOfTheDash = AttackToResolve().movementOfTheCharacter.movementToApply.length;

		shapePreview.Init(AttackToResolve().rangeOfTheAttack, AttackToResolve().angleToAttackFrom, 0, Vector3.up*distanceOfTheDash);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (canBeCast())
			
		{
			print("ShowPreview");
			shapePreview.gameObject.SetActive(true);
		}
	}

	protected override void HidePreview ()
	{
		base.HidePreview();

		print("hidePreview");
		shapePreview.gameObject.SetActive(false);
	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if(canBeCast())
		{
			ShowPreview(myPlayerModule.mousePos());
			if (spell.lockRotOnCanalisation)
				myPlayerModule.rotationLock(true);
		}

		base.StartCanalysing(_BaseMousePos);
	}
	//EFFET DU SORT
	void ResolveAttack ( Vector3 _mousePos )
	{
		if (isUsed)
		{
			isUsed = false;
			HidePreview();
			//ptit dash tu connais
			if (AttackToResolve().movementOfTheCharacter == null)
			{
				ResolveSlash();
			}
			else
			{
				myPlayerModule.forcedMovementInterrupted += ResolveSlash;

				/*if (spell.useLastRecordedMousePos)
					myPlayerModule.movementPart.AddDash(AttackToResolve().movementOfTheCharacter.MovementToApply(transform.forward, transform.position));
				else
					myPlayerModule.movementPart.AddDash(AttackToResolve().movementOfTheCharacter.MovementToApply(myPlayerModule.mousePos(), transform.position));*/
				myPlayerModule.movementPart.AddDash(AttackToResolve().movementOfTheCharacter.MovementToApply(transform.position + transform.forward, transform.position));
			}
		}
	}

	void ResolveSlash ()
	{
		CacAttackParameters _trad =	AttackToResolve();

		if (AttackToResolve().movementOfTheCharacter != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
		}

		List<GameObject> _listHit = new List<GameObject>();

		float _angle = -_trad.angleToAttackFrom / 2;

		//RAYCAST POUR TOUCHER
		for (int i = 0; i < _trad.angleToAttackFrom; i++)
		{
			Vector3 _direction = Quaternion.Euler(0, _angle, 0) * transform.forward;
			_angle++;

			Ray _ray = new Ray(transform.position + Vector3.up * 1.2f, _direction);
			RaycastHit[] _allhits = Physics.RaycastAll(_ray, _trad.rangeOfTheAttack, 1 << 8);

			Ray _debugRay = new Ray(transform.position + Vector3.up * 1.2f, _direction);
			Debug.DrawRay(_ray.origin, _debugRay.direction * _trad.rangeOfTheAttack, Color.red, 5);

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

			//RAJOUTER LES PLAYERS DATAS ICI
			_playerTouched.DealDamages(AttackToResolve().damagesToDeal,transform.position);
		}

	

		Interrupt();
	}

	CacAttackParameters AttackToResolve ()
	{
		if (currentTimeCanalised >= localTrad.timeToCanalyseToUpgrade)
			return localTrad.upgradedAttack;
		else
			return localTrad.normalAttack;
	}

	//rajout des status 
	protected override void ApplyStatusCanalisation ()
	{
		myPlayerModule.state |= En_CharacterState.Canalysing;

		if (localTrad.lockPosOnCanalisation)
			myPlayerModule.state |= En_CharacterState.Root;
	}

	//on les clear
	public override void Interrupt ()
	{
		base.Interrupt();
		//clear le canalysing et le root
		#region
		myPlayerModule.state = (myPlayerModule.state & ~En_CharacterState.Canalysing);

		if (localTrad.lockPosOnCanalisation)
			myPlayerModule.state = (myPlayerModule.state & ~En_CharacterState.Root);
		#endregion
	}

	//FONCTION ECRASED
	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		return;
	}

	protected override void TreatNormalCanalisation ()
	{
		return;
	}


}
