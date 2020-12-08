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
	[SerializeField] TextMeshProUGUI myChargesText;

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
			myChargesText.gameObject.GetComponentInParent<GameObject>().SetActive(false);
		else
		{
			myChargesText.text = charges.ToString();
			ChargeUpdate += UpdateChargeUiOnLifeBar;
		}

	}

	private void OnDisable ()
	{
		ChargeUpdate -= UpdateChargeUiOnLifeBar;
	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
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
		myChargesText.text = charges.ToString();
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