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
	CacAttackParameters attackToResolve;
	float finalTimeCanalised;

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

	protected override void LinkInputs ( En_SpellInput _actionLinked )
	{
		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += ShowPreview;
				myPlayerModule.firstSpellInput += StartCanalysing;
				myPlayerModule.firstSpellInputRealeased += AnonceSpell;
				myPlayerModule.firstSpellInputRealeased += HidePreview;

				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += ShowPreview;
				myPlayerModule.secondSpellInput += StartCanalysing;
				myPlayerModule.secondSpellInputRealeased += AnonceSpell;
				myPlayerModule.secondSpellInputRealeased += HidePreview;

				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += ShowPreview;
				myPlayerModule.thirdSpellInput += StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased += AnonceSpell;
				
				myPlayerModule.thirdSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += ShowPreview;
				myPlayerModule.leftClickInput += StartCanalysing;
				myPlayerModule.leftClickInputRealeased += AnonceSpell;
				myPlayerModule.leftClickInputRealeased += HidePreview;

				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput += ShowPreview;
				myPlayerModule.wardInput += StartCanalysing;
				myPlayerModule.wardInputReleased += AnonceSpell;
				myPlayerModule.wardInputReleased += HidePreview;

				break;
		}
	}

	protected override void Disable ()
	{
		base.Disable();
	}

	protected override void DelinkInput ()
	{
		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInput -= StartCanalysing;
				myPlayerModule.firstSpellInputRealeased -= AnonceSpell;
				myPlayerModule.firstSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= ShowPreview;
				myPlayerModule.secondSpellInput -= StartCanalysing;
				myPlayerModule.secondSpellInputRealeased -= AnonceSpell;
				myPlayerModule.secondSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= ShowPreview;
				myPlayerModule.thirdSpellInput -= StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased -= AnonceSpell;
				myPlayerModule.thirdSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= ShowPreview;
				myPlayerModule.leftClickInput -= StartCanalysing;
				myPlayerModule.leftClickInputRealeased -= AnonceSpell;
				myPlayerModule.leftClickInputRealeased -= HidePreview;
				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= ShowPreview;
				myPlayerModule.wardInput -= StartCanalysing;
				myPlayerModule.wardInputReleased -= AnonceSpell;
				myPlayerModule.wardInputReleased -= HidePreview;
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
		shapePreview.Init(FinalRange(currentTimeCanalised), AttackToResolve().angleToAttackFrom, 0, Vector3.zero);
	}



	protected override void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())
		{
			shapePreview.gameObject.SetActive(true);
		}
		base.ShowPreview(mousePos);

	}

	protected override void HidePreview ( Vector3 _temp)
	{
		base.HidePreview(_temp);
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
	

	float FinalRange(float _timeCanlised)
	{
		return localTrad.normalAttack.rangeOfTheAttack + (Mathf.Clamp(_timeCanlised / localTrad.timeToCanalyseToUpgrade, 0, 1)) * variationOfRange;
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		ResolveSlash();
	}

	protected override void AnonceSpell ( Vector3 _toAnnounce )
	{
		attackToResolve = AttackToResolve();
		finalTimeCanalised = currentTimeCanalised;
		base.AnonceSpell(_toAnnounce);
	}

	void ResolveSlash ()
	{
		HidePreview(Vector3.zero);

		if (spell.forcedMovementAppliedBeforeResolution != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
		}

		List<GameObject> _listHit = new List<GameObject>();

		float _angle = -attackToResolve.angleToAttackFrom / 2;

		//RAYCAST POUR TOUCHER
		for (int i = 0; i < attackToResolve.angleToAttackFrom; i++)
		{
			Vector3 _direction = Quaternion.Euler(0, _angle, 0) * transform.forward;
			_angle++;

			Ray _ray = new Ray(transform.position + Vector3.up * 1.2f, _direction);
			RaycastHit[] _allhits = Physics.RaycastAll(_ray, FinalRange(finalTimeCanalised), 1 << 8);

			Ray _debugRay = new Ray(transform.position + Vector3.up * 1.2f, _direction);
			Debug.DrawRay(_ray.origin, _debugRay.direction * FinalRange(finalTimeCanalised), Color.red, 5);

			//verif que le gameobject est pas deja dansa la liste
			for (int j = 0; j < _allhits.Length; j++)
			{
				if (!_listHit.Contains(_allhits[j].collider.gameObject))
				{
					_listHit.Add(_allhits[j].collider.gameObject);
				}
			}
		}

		_listHit.Remove(gameObject);

		foreach (GameObject _go in _listHit)
		{
			LocalPlayer _playerTouched = _go.GetComponent<LocalPlayer>();

			if(_playerTouched.myPlayerModule.teamIndex != myPlayerModule.teamIndex)
				_playerTouched.DealDamages(attackToResolve.damagesToDeal,transform.position);
		}
	}
	
	CacAttackParameters AttackToResolve ()
	{
		if (timeCanalised >= localTrad.timeToCanalyseToUpgrade)
		{
			return localTrad.upgradedAttack;
		}
		else
		{
			return localTrad.normalAttack;
		}
	}

	protected override void CancelSpell ( bool _isForcedInterrupt )
	{
		base.CancelSpell(_isForcedInterrupt);
		if (showingPreview)
		{
			KillSpell();
			DecreaseCharge();
		}
	}

}
