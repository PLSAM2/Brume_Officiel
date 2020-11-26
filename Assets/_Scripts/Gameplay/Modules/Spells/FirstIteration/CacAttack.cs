using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	ShapePreview shapePreview;
	float timeCanalised;
	float variationOfRange => localTrad.upgradedAttack.rangeOfTheAttack -  localTrad.normalAttack.rangeOfTheAttack ;

	private void Awake ()
	{
		localTrad = (Sc_CacAttack)spell;
	}

	//inputs
	#region
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
				myPlayerModule.firstSpellInputRealeased += AnonceSpell;
				break;

			case En_SpellInput.SecondSpell:
				//myPlayerModule.secondSpellInput += ShowPreview;
				myPlayerModule.secondSpellInput += StartCanalysing;
				myPlayerModule.secondSpellInputRealeased += AnonceSpell;
				break;

			case En_SpellInput.ThirdSpell:
				//myPlayerModule.thirdSpellInput += ShowPreview;
				myPlayerModule.thirdSpellInput += StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased += AnonceSpell;
				break;

			case En_SpellInput.Click:
				//myPlayerModule.leftClickInput += ShowPreview;
				myPlayerModule.leftClickInput += StartCanalysing;
				myPlayerModule.leftClickInputRealeased += AnonceSpell;
				break;

			case En_SpellInput.Ward:
				//myPlayerModule.wardInput += ShowPreview;
				myPlayerModule.wardInput += StartCanalysing;
				myPlayerModule.wardInputReleased += AnonceSpell;
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
				myPlayerModule.firstSpellInputRealeased -= AnonceSpell;
				break;

			case En_SpellInput.SecondSpell:
				//myPlayerModule.secondSpellInput -= ShowPreview;
				myPlayerModule.secondSpellInput -= StartCanalysing;
				myPlayerModule.secondSpellInputRealeased -= AnonceSpell;
				break;

			case En_SpellInput.ThirdSpell:
			//	myPlayerModule.thirdSpellInput -= ShowPreview;
				myPlayerModule.thirdSpellInput -= StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased -= AnonceSpell;
				break;

			case En_SpellInput.Click:
			//	myPlayerModule.leftClickInput -= ShowPreview;
				myPlayerModule.leftClickInput -= StartCanalysing;
				myPlayerModule.leftClickInputRealeased -= AnonceSpell;
				break;

			case En_SpellInput.Ward:
			//	myPlayerModule.wardInput -= ShowPreview;
				myPlayerModule.wardInput -= StartCanalysing;
				myPlayerModule.wardInputReleased -= AnonceSpell;
				break;
		}
	}
	#endregion

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		if (isUsed && !anonciated)
			timeCanalised += Time.fixedDeltaTime;
	}

	//PREVIEW
	protected override void UpdatePreview ()
	{
		base.UpdatePreview();

		float distanceOfTheDash = 0;

		if (spell.forcedMovementAppliedBeforeResolution != null)
			distanceOfTheDash = spell.forcedMovementAppliedBeforeResolution.movementToApply.length;

		shapePreview.Init(FinalRange(), AttackToResolve().angleToAttackFrom, 0, Vector3.up*distanceOfTheDash);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (canBeCast())
			
		{
			shapePreview.gameObject.SetActive(true);
		}
	}

	protected override void HidePreview ()
	{
		base.HidePreview();
		shapePreview.gameObject.SetActive(false);
	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if(canBeCast())
		{
			ShowPreview(myPlayerModule.mousePos());
			timeCanalised = 0;
		}

		base.StartCanalysing(_BaseMousePos);
	}
	

	float FinalRange()
	{
		return localTrad.normalAttack.rangeOfTheAttack + (Mathf.Clamp(currentTimeCanalised / localTrad.timeToCanalyseToUpgrade, 0, 1)) * variationOfRange;
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		ResolveSlash();
	}

	void ResolveSlash ()
	{
		CacAttackParameters _trad =	AttackToResolve();

		if (spell.forcedMovementAppliedBeforeResolution != null)
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
			RaycastHit[] _allhits = Physics.RaycastAll(_ray, FinalRange(), 1 << 8);

			Ray _debugRay = new Ray(transform.position + Vector3.up * 1.2f, _direction);
			Debug.DrawRay(_ray.origin, _debugRay.direction * FinalRange(), Color.red, 5);

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
		if (timeCanalised >= localTrad.timeToCanalyseToUpgrade)
			return localTrad.upgradedAttack;
		else
			return localTrad.normalAttack;
	}
}
