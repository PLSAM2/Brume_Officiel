﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Module_Cac : SpellModule
{
	Sc_CacAttack localTrad;
	ShapePreview shapePreview, shapePreviewNetwork;
	float variationOfRange => localTrad.upgradedAttack.rangeOfTheAttack - localTrad.normalAttack.rangeOfTheAttack;
	CacAttackParameters attackToResolve;

	int _attackIndex = 0;
	int attackIndex { get => _attackIndex; set { _attackIndex = value; } }
	[SerializeField] Image delayIndicator;
	float _delayBetweenSwing;
	bool inCombo = false;
	float delayBetweenSwing
	{
		get => _delayBetweenSwing; set { _delayBetweenSwing = value; delayIndicator.fillAmount = Mathf.Clamp(localTrad.timeToStopCombo - delayBetweenSwing / localTrad.timeToStopCombo, 0, 1); }
	}

	bool isSetuped = false;
	//inputs


	#region
	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		localTrad = (Sc_CacAttack)spell;


		shapePreview = PreviewManager.Instance.GetShapePreview();
		shapePreview.gameObject.SetActive(false);
		shapePreviewNetwork = PreviewManager.Instance.GetShapePreview();
		shapePreviewNetwork.gameObject.SetActive(false);
		attackIndex = 0;
		attackToResolve = localTrad.attackList[attackIndex];

		base.SetupComponent(_actionLinked);
		isSetuped = true;
		if (!myPlayerModule.mylocalPlayer.isOwner)
			delayIndicator.gameObject.SetActive(false);

	}

	protected override void LinkInputs ( En_SpellInput _actionLinked )
	{
		myPlayerModule.cancelSpell += CancelSpell;

		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += StartCanalysing;
				myPlayerModule.leftClickInput += StartCombo;
				myPlayerModule.leftClickInputRealeased += EndCombo;
				//myPlayerModule.firstSpellInputRealeased += AnonceSpell;
				//myPlayerModule.firstSpellInputRealeased += HidePreview;

				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += StartCanalysing;
				myPlayerModule.secondSpellInput += StartCombo;
				myPlayerModule.secondSpellInputRealeased += EndCombo;
				//myPlayerModule.secondSpellInputRealeased += AnonceSpell;
				//	myPlayerModule.secondSpellInputRealeased += HidePreview;

				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += StartCanalysing;
				myPlayerModule.thirdSpellInput += StartCombo;
				myPlayerModule.thirdSpellInputRealeased += EndCombo;
				//myPlayerModule.thirdSpellInputRealeased += AnonceSpell;
				//	myPlayerModule.thirdSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += StartCanalysing;
				myPlayerModule.leftClickInput += StartCombo;
				myPlayerModule.leftClickInputRealeased += EndCombo;
				//	myPlayerModule.leftClickInputRealeased += AnonceSpell;
				//	myPlayerModule.leftClickInputRealeased += HidePreview;

				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput += StartCanalysing;
				myPlayerModule.wardInput += StartCombo;
				myPlayerModule.wardInputReleased += EndCombo;
				//	myPlayerModule.wardInputReleased += AnonceSpell;
				//myPlayerModule.wardInputReleased += HidePreview;

				break;
		}
	}

	protected override void DelinkInput ()
	{
		myPlayerModule.cancelSpell -= CancelSpell;

		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= StartCanalysing;
				myPlayerModule.leftClickInput -= StartCombo;
				myPlayerModule.leftClickInputRealeased -= EndCombo;
				//	myPlayerModule.firstSpellInputRealeased -= AnonceSpell;
				//	myPlayerModule.firstSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= StartCanalysing;
				myPlayerModule.secondSpellInputRealeased -= EndCombo;
				myPlayerModule.secondSpellInput -= StartCombo;
				//	myPlayerModule.secondSpellInputRealeased -= AnonceSpell;
				//	myPlayerModule.secondSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= StartCanalysing;
				myPlayerModule.thirdSpellInput -= StartCombo;
				myPlayerModule.thirdSpellInputRealeased -= EndCombo;
				//	myPlayerModule.thirdSpellInputRealeased -= AnonceSpell;
				//	myPlayerModule.thirdSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= StartCanalysing;
				myPlayerModule.leftClickInput -= StartCombo;
				myPlayerModule.leftClickInputRealeased -= EndCombo;
				//	myPlayerModule.leftClickInputRealeased -= AnonceSpell;
				//	myPlayerModule.leftClickInputRealeased -= HidePreview;
				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= StartCanalysing;
				myPlayerModule.wardInput -= StartCombo;
				myPlayerModule.wardInputReleased -= EndCombo;
				//	myPlayerModule.wardInputReleased -= AnonceSpell;
				//	myPlayerModule.wardInputReleased -= HidePreview;
				break;
		}
	}

	#endregion
	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		if (isSetuped)
		{
			if (delayBetweenSwing >= localTrad.timeToStopCombo)
			{
				attackIndex = 0;
			}

			if (!isUsed)
			{
				delayBetweenSwing += Time.fixedDeltaTime;
			}
		}
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();

		shapePreview.Init(FinalRange(currentTimeCanalised), AttackToResolve().angleToAttackFrom, transform.eulerAngles.y, transform.position);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())
		{
			shapePreview.gameObject.SetActive(true);
		}
		base.ShowPreview(mousePos);
	}

	protected override void HidePreview ( Vector3 _temp )
	{
		base.HidePreview(_temp);
		shapePreview.gameObject.SetActive(false);
	}

	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if (canBeCast())
		{
			print("StartCanal");
			mousePosInputed = _BaseMousePos;
			ShowPreview(mousePosInputed);

			base.StartCanalysing(_BaseMousePos);

			delayBetweenSwing = 0;
		}
	}


	float FinalRange ( float _timeCanlised )
	{
		return AttackToResolve().rangeOfTheAttack;
		//localTrad.normalAttack.rangeOfTheAttack + (Mathf.Clamp(_timeCanlised / localTrad.timeToCanalyseToUpgrade, 0, 1)) * variationOfRange;
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		ResolveSlash();
	}

	protected override void AnonceSpell ( Vector3 _toAnnounce )
	{
		if (!anonciated)
		{
			attackToResolve = AttackToResolve();
			base.AnonceSpell(_toAnnounce);
		}
	}

	void ResolveSlash ()
	{
		HidePreview(Vector3.zero);

		if (attackToResolve.forcedMovementToApplyAfterRealisation != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
		}

		if (willResolve)
		{
			List<GameObject> _listHit = new List<GameObject>();

			float _angle = -attackToResolve.angleToAttackFrom / 2;

			//RAYCAST POUR TOUCHER
			for (int i = 0; i < attackToResolve.angleToAttackFrom; i++)
			{
				Vector3 _direction = Quaternion.Euler(0, _angle, 0) * transform.forward;
				_angle++;

				Ray _ray = new Ray(transform.position + Vector3.up * 1.2f, _direction);
				RaycastHit[] _allhits = Physics.RaycastAll(_ray, FinalRange(0), 1 << 8);

				Ray _debugRay = new Ray(transform.position + Vector3.up * 1.2f, _direction);
				Debug.DrawRay(_ray.origin, _debugRay.direction * FinalRange(0), Color.red, 5);

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

				if (_playerTouched.myPlayerModule.teamIndex != myPlayerModule.teamIndex)
					_playerTouched.DealDamages(attackToResolve.damagesToDeal, transform.position);
			}
		}

		if (attackIndex < localTrad.attackList.Length - 1)
			attackIndex++;
		else
			attackIndex = 0;
	}

	public override void Interrupt ()
	{
		base.Interrupt();

		if (inCombo)
			StartCanalysing(myPlayerModule.mousePos());
	}
	CacAttackParameters AttackToResolve ()
	{
		return localTrad.attackList[attackIndex];
	}

	protected override void CancelSpell ( bool _isForcedInterrupt )
	{
		base.CancelSpell(_isForcedInterrupt);
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Interrupt");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Interrupt");
		resolved = anonciated = startResolution = true;
		currentTimeCanalised = 0;
		throwbackTime = 0;
		willResolve = false;
		HidePreview(Vector3.zero);
	}

	public void ShowAttackPreviewNetwork ( float _timeCounted )
	{
		ShapePreview _mypreview = PreviewManager.Instance.GetShapePreview();

		if (_timeCounted >= localTrad.timeToCanalyseToUpgrade)
		{
			_mypreview.Init(localTrad.upgradedAttack.rangeOfTheAttack, localTrad.upgradedAttack.angleToAttackFrom, transform.eulerAngles.y, transform.position);
		}
		else
		{
			_mypreview.Init(localTrad.normalAttack.rangeOfTheAttack, localTrad.normalAttack.angleToAttackFrom, transform.eulerAngles.y, transform.position);
		}

		if (myPlayerModule.teamIndex == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
			_mypreview.SetColor(Color.yellow, .2f);
		else
			_mypreview.SetColor(Color.red, .2f);

		_mypreview.SetLifeTime(spell.throwBackDuration);

	}


	public void EvaluatePreviewNetwork ( float timeCounted )
	{
		if (!myPlayerModule.mylocalPlayer.isOwner)
		{

		}
		if (timeCounted >= localTrad.timeToCanalyseToUpgrade)
		{
			shapePreviewNetwork.Init(localTrad.upgradedAttack.rangeOfTheAttack, localTrad.upgradedAttack.angleToAttackFrom, transform.eulerAngles.y, transform.position);

			if (myPlayerModule.teamIndex == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
				shapePreviewNetwork.SetColor(Color.yellow, 155);
			else
				shapePreviewNetwork.SetColor(Color.red, 155);
		}
		else
		{
			shapePreviewNetwork.Init(localTrad.normalAttack.rangeOfTheAttack, localTrad.normalAttack.angleToAttackFrom, transform.eulerAngles.y, transform.position);

			if (myPlayerModule.teamIndex == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
				shapePreviewNetwork.SetColor(Color.yellow, 155);
			else
				shapePreviewNetwork.SetColor(Color.red, 155);
		}

	}

	public void ShowPreviewNetwork ( bool isShowed )
	{
		shapePreviewNetwork.gameObject.SetActive(isShowed);
	}

	void StartCombo ( Vector3 _useless )
	{
		inCombo = true;
	}

	void EndCombo ( Vector3 _useless )
	{
		inCombo = false;
	}

	protected override Sc_ForcedMovement ForcedMovementToApplyOnRealisation ()
	{ return attackToResolve.forcedMovementToApplyOnRealisation; }

	protected override Sc_ForcedMovement ForcedMovementToApplyAfterRealisation ()
	{ return attackToResolve.forcedMovementToApplyAfterRealisation; }

	protected override float FinalCanalisationTime ()
	{ return attackToResolve.canalisationTime; }

	protected override float FinalAnonciationTime ()
	{ return attackToResolve.canalisationTime - attackToResolve.anonciationTime; }
	protected override void DecreaseCharge ()
	{
		return;
	}
}
