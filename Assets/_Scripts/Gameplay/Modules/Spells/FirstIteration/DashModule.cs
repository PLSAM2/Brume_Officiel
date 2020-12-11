using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class DashModule : SpellModule
{
	public bool usingKeyboardInput = true;
	ArrowPreview myPreviewArrow;
	Sc_DashSpell localTrad;
	Vector3 directionRecorded;
	[SerializeField] GameObject[] myChargesUi;

    protected override void ResolveSpell()
    {
        base.ResolveSpell();
    }

    public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);

		myPreviewArrow = PreviewManager.Instance.GetArrowPreview();
		HidePreview(Vector3.zero);

		localTrad = spell as Sc_DashSpell;

		if (!myPlayerModule.mylocalPlayer.isOwner)
			myChargesUi[0].transform.parent.gameObject.SetActive(false);
		else
		{
			ChargeUpdate += UpdateChargeUiOnLifeBar;
			foreach (GameObject _image in myChargesUi)
				_image.SetActive(true);
		}

	}

	private void OnDisable ()
	{
		ChargeUpdate -= UpdateChargeUiOnLifeBar;
	}

	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		directionRecorded = myPlayerModule.directionInputed();
		base.StartCanalysing(_BaseMousePos);
	}

	protected override bool canBeCast ()
	{
		if (myPlayerModule.directionInputed() == Vector3.zero)
			return false;
		else
			return base.canBeCast();
	}

	protected override void TreatForcedMovement ( Sc_ForcedMovement movementToTreat )
	{
		if(!usingKeyboardInput)
			base.TreatForcedMovement(movementToTreat);
		else
			myPlayerModule.movementPart.AddDash(movementToTreat.MovementToApply(transform.position + directionRecorded, transform.position));

	}

	void UpdateChargeUiOnLifeBar(int numberOfCharges)
	{
		foreach (GameObject _image in myChargesUi)
			_image.SetActive(false);

		for (int i =0; i < numberOfCharges; i ++)
		{
			myChargesUi[i].SetActive(true);
		}
	}

	//preview
	#region
	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (canBeCast())
		{
			myPreviewArrow.gameObject.SetActive(true);
		}
	}

	protected override void HidePreview (Vector3 _temp)
	{
		base.HidePreview(_temp);
		myPreviewArrow.gameObject.SetActive(false);
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();

		if (usingKeyboardInput)
		{
			if (myPlayerModule.directionInputed() == Vector3.zero)
				myPreviewArrow.gameObject.SetActive(false);
			else
				myPreviewArrow.gameObject.SetActive(true);

			myPreviewArrow.Init(transform.position, transform.position + (myPlayerModule.directionInputed() * spell.range), .1f);
		}

		else
			myPreviewArrow.Init(transform.position, transform.position + (Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * spell.range), .1f);
	}
	#endregion

	//upgrade
	#region
	protected override void UpgradeSpell ()
	{
		base.UpgradeSpell();
		charges += localTrad.bonusDash;
	}

	protected override void ReturnToNormal ()
	{
		base.ReturnToNormal();
		charges = Mathf.Clamp(charges, 0, spell.numberOfCharge);
	}
	#endregion
}