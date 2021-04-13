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
		set
		{
			_delayBetweenSwing = value;
			delayIndicator.fillAmount = Mathf.Clamp((timeToStopCombo - delayBetweenSwing) / timeToStopCombo, 0, 1);
		}
	}
	ushort _comboIndex = 0;
	ushort comboIndex { get => _comboIndex; set { _comboIndex = value; indexOfCombo.text = _comboIndex.ToString();
			myPlayerModule.mylocalPlayer.myAnimController.SetIntToAnim("ComboIndex", _comboIndex);
			myPlayerModule.mylocalPlayer.myAnimController.SyncInt("ComboIndex", _comboIndex);
		} }
	ushort oldIndex=0;
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

	void TryToCombo ()
	{
		myPlayerModule.spellResolved -= TryToCombo;

		oldIndex = comboIndex;

		if (comboIndex == allSpellsOfTheCombo.Length - 1)
		{
			comboIndex = 0;
		}
		else
			comboIndex += 1;

		Interrupt();

		if (inCombo)
		{
			StartCanalysing(myPlayerModule.mousePos());
		}
	}

	protected  void FixedUpdate ()
	{

		if (!isUsed && delayBetweenSwing > 0)
		{
			delayBetweenSwing -= Time.fixedDeltaTime;
		}

		if (delayBetweenSwing < 0 && !isUsed)
			comboIndex = 0;

	}
	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		willResolve = true;
		base.StartCanalysing(_BaseMousePos);
	}

	protected override void ResolveSpell ()
	{
		delayBetweenSwing = timeToStopCombo;

		

		allSpellsOfTheCombo[comboIndex].StartCanalysing(myPlayerModule.mousePos());
		myPlayerModule.spellResolved += TryToCombo;

		base.ResolveSpell();

	}

	protected override void TreatThrowBack ()
	{
		return;
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

	public override void KillSpell ()
	{
		comboIndex = oldIndex;
		allSpellsOfTheCombo[comboIndex].KillSpell();
		base.KillSpell();
	}
}
