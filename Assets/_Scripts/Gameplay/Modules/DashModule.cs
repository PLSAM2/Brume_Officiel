using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DashModule : SpellModule
{
	public LineRenderer mylineRender;
	[SerializeField] Color startColorPreview = Color.red, endColorPreview = Color.blue;
	public override void SetupComponent ()
	{
		base.SetupComponent();
		mylineRender.useWorldSpace = true;


		startCanalisation += ShowPreview;
		endCanalisation += ClearPreview;
		myPlayerModule.forcedMovementInterrupted += EndDashFeedback;
	}

	public override void OnDisable ()
	{
		startCanalisation -= ShowPreview;
		endCanalisation -= ClearPreview;
		myPlayerModule.forcedMovementInterrupted-= EndDashFeedback;
	}
	public override void ResolveSpell ( Vector3 _mousePosition )
	{

		Sc_DashSpell _localTraduction = spell as Sc_DashSpell;
		ForcedMovement dashInfos = new ForcedMovement();
		dashInfos.duration = _localTraduction.timeToReachMaxRange;
		dashInfos.strength = _localTraduction.range / dashInfos.duration;

		if (spell.useLastRecordedMousePos)
		{
			dashInfos.direction = recordedMousePosOnInput - transform.position;
		}
		else
		{
			dashInfos.direction = myPlayerModule.mousePos() - transform.position;
		}

		myPlayerModule.forcedMovementAdded(dashInfos);
		base.ResolveSpell(_mousePosition);

	}

	public virtual void ShowPreview ()
	{
		mylineRender.positionCount += 1;
		if (spell.useLastRecordedMousePos)
		{
			mylineRender.SetPosition(1, transform.position + Vector3.Normalize(recordedMousePosOnInput - transform.position) * spell.range);
		}
		else
		{
			mylineRender.SetPosition(1, transform.position + Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * spell.range);
		}

		mylineRender.DOColor(new Color2(startColorPreview, startColorPreview), new Color2(endColorPreview, endColorPreview), spell.canalisationTime);
	}

	public virtual void ClearPreview()
	{
		mylineRender.positionCount = 1;
	}
	
	void UpdatePreview()
	{
		mylineRender.SetPosition(0,new Vector3(transform.position.x, 0.2f, transform.position.z));
		if (spell.useLastRecordedMousePos)
		{
			mylineRender.SetPosition(1, transform.position + Vector3.Normalize(new Vector3(recordedMousePosOnInput.x - transform.position.x, transform.position.y, recordedMousePosOnInput.z - transform.position.z)) * spell.range);
		}
		else
		{
			mylineRender.SetPosition(1, transform.position + Vector3.Normalize(new Vector3(myPlayerModule.mousePos().x - transform.position.x, transform.position.y, myPlayerModule.mousePos().z - transform.position.z)) * spell.range);
		}
	}

	public override void Update ()
	{
		base.Update();

		if(isUsed)
		{
			UpdatePreview();
		}
	}

	

	void EndDashFeedback()
	{
		myPlayerModule.mylocalPlayer.triggerAnim.Invoke("End");
	}

}
