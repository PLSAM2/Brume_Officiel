using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ModuleCombo : SpellModule
{
	public SpellModule[] allSpellsOfTheCombo;
	public float timeToStopCombo = 2;
	bool inCombo = false;
	[SerializeField] Image delayIndicator;
	[SerializeField] TextMeshProUGUI indexOfCombo;
	float _delayBetweenSwing;
	float delayBetweenSwing
	{
		get => _delayBetweenSwing; 
		set { _delayBetweenSwing = value; 
			delayIndicator.fillAmount = Mathf.Clamp((timeToStopCombo - delayBetweenSwing) / timeToStopCombo, 0, 1);
		}
	}
	int _comboIndex = 0;
	int comboIndex {get => _comboIndex; set {_comboIndex = value; indexOfCombo.text = _comboIndex.ToString(); } }

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);

		if (!myPlayerModule.mylocalPlayer.isOwner)
			delayIndicator.gameObject.SetActive(false);

		foreach (SpellModule _module in allSpellsOfTheCombo)
		{
			_module.isAComboPiece = true;
			_module.SetupComponent(actionLinked);

		}
		comboIndex = 0;
	}

	void StartCombo ( Vector3 _useless )
	{
		inCombo = true;
	}

	void EndCombo ( Vector3 _useless )
	{
		inCombo = false;
	}

	void Combo ()
	{
		if (inCombo)
		{
			ResolveSpell();
		}
	}

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		if (!isUsed && delayBetweenSwing>0)
		{
			delayBetweenSwing -= Time.fixedDeltaTime;
		}

		if (delayBetweenSwing < 0)
			comboIndex = 0;

	}
	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		willResolve = true;
		base.StartCanalysing(_BaseMousePos);
	}

	protected override void ResolveSpell ()
	{
		print("TryToAttack");
		delayBetweenSwing = timeToStopCombo;
		allSpellsOfTheCombo[comboIndex].StartCanalysing(myPlayerModule.mousePos());

		if (comboIndex == allSpellsOfTheCombo.Length - 1)
			comboIndex = 0;
		else
			comboIndex++;
		base.ResolveSpell();

	}

	protected override void TreatThrowBack ()
	{
		return;
	}

	protected override void LinkInputs ( En_SpellInput _actionLinked )
	{
		foreach (SpellModule _module in allSpellsOfTheCombo)
		{
			_module.SpellResolved += Combo;
			_module.SpellResolved += TryToEnd;
		}

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

		foreach (SpellModule _module in allSpellsOfTheCombo)
		{
			_module.SpellResolved -= Combo;
			_module.SpellResolved -= TryToEnd;

		}

		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= StartCanalysing;
				myPlayerModule.leftClickInput -= StartCombo;
				myPlayerModule.leftClickInputRealeased -= EndCombo;
				//myPlayerModule.firstSpellInputRealeased += AnonceSpell;
				//myPlayerModule.firstSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= StartCanalysing;
				myPlayerModule.secondSpellInput -= StartCombo;
				myPlayerModule.secondSpellInputRealeased -= EndCombo;
				//myPlayerModule.secondSpellInputRealeased += AnonceSpell;
				//	myPlayerModule.secondSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= StartCanalysing;
				myPlayerModule.thirdSpellInput -= StartCombo;
				myPlayerModule.thirdSpellInputRealeased -= EndCombo;
				//myPlayerModule.thirdSpellInputRealeased += AnonceSpell;
				//	myPlayerModule.thirdSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= StartCanalysing;
				myPlayerModule.leftClickInput -= StartCombo;
				myPlayerModule.leftClickInputRealeased -= EndCombo;
				//	myPlayerModule.leftClickInputRealeased += AnonceSpell;
				//	myPlayerModule.leftClickInputRealeased += HidePreview;
				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= StartCanalysing;
				myPlayerModule.wardInput -= StartCombo;
				myPlayerModule.wardInputReleased -= EndCombo;
				//	myPlayerModule.wardInputReleased += AnonceSpell;
				//myPlayerModule.wardInputReleased += HidePreview;
				break;
		}
	}

	protected override void DecreaseCharge ()
	{
		return;
	}

	protected override void ApplyCanalisationEffect ()
	{
		return;
	}

	protected override void KillSpell ()
	{
		comboIndex = Mathf.Clamp(comboIndex -1, 0, allSpellsOfTheCombo.Length - 1);
		base.KillSpell();
	}

	void TryToEnd()
	{
		if (!inCombo)
			Interrupt();
		else
			return;
	}

}
