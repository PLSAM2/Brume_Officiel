using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DashModule : SpellModule
{
	public bool usingKeyboardInput =true;
	ArrowPreview myPreviewArrow;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			myPlayerModule.forcedMovementInterrupted += EndDashFeedback;
		}
		myPreviewArrow = PreviewManager.Instance.GetArrowPreview();
		HidePreview();
	}

	protected override void Disable ()
	{
		base.Disable();
        if (myPlayerModule.mylocalPlayer.isOwner)
        {
			myPlayerModule.forcedMovementInterrupted -= EndDashFeedback;
		}
	}
	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{

		HidePreview();

		base.StartCanalysing(_BaseMousePos);
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{

		Sc_DashSpell _localTraduction = spell as Sc_DashSpell;
		ForcedMovement dashInfos = new ForcedMovement();

		if (_localTraduction.adaptiveRange)
		{
			float speedOfDash = _localTraduction.range / _localTraduction.timeToReachMaxRange;

			if (spell.useLastRecordedMousePos)
			{
			/*	dashInfos.duration = Vector3.Distance(recordedMousePosOnInput, transform.position)/ speedOfDash;
				print(dashInfos.duration);*/

			}
			else
			{
				/*dashInfos.duration = (_localTraduction.range / _localTraduction.timeToReachMaxRange) / Vector3.Distance(myPlayerModule.mousePos(), transform.position);*/

			}
		}
		else
		{
			dashInfos.duration = _localTraduction.timeToReachMaxRange;
		}

		dashInfos.strength = _localTraduction.range / dashInfos.duration;


		if (spell.useLastRecordedMousePos)
		{
			if (usingKeyboardInput)
				dashInfos.direction = lastRecordedDirection;
			else
				dashInfos.direction = recordedMousePosOnInput - transform.position;
		}
		else
		{
			if (usingKeyboardInput)
				dashInfos.direction = myPlayerModule.directionInputed();
			else
				dashInfos.direction = myPlayerModule.mousePos() - transform.position;
		}
		myPlayerModule.forcedMovementAdded(dashInfos);
		base.ResolveSpell(_mousePosition);

	}

	void EndDashFeedback()
	{
		myPlayerModule.mylocalPlayer.triggerAnim.Invoke("End");
	}

	protected override void UpgradeSpell ( )
	{
		base.UpgradeSpell();
		Sc_DashSpell dashSpell = spell as Sc_DashSpell;
		charges += dashSpell.bonusDash;
	}

	protected override void ReturnToNormal ()
	{
		base.ReturnToNormal();
		charges = Mathf.Clamp(charges, 0, spell.numberOfCharge);
	}

	protected override bool canBeCast ()
	{
		if (myPlayerModule.directionInputed() == Vector3.zero)
			return false;
		else
			return base.canBeCast();
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (canBeCast())
		{
			myPreviewArrow.gameObject.SetActive(true);
		}
	}

	protected override void HidePreview ()
	{
		base.HidePreview();
		myPreviewArrow.gameObject.SetActive(false);
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();

		if (spell.useLastRecordedMousePos)
			myPreviewArrow.Init(transform.position, transform.position + (Vector3.Normalize(lastRecordedDirection) * spell.range), .1f);
		else
			myPreviewArrow.Init(transform.position, transform.position + (Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * spell.range), .1f);
	}

}