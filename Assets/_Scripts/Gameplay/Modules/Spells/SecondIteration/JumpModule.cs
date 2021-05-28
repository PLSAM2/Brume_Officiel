using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using static AOE_Fx;

public class JumpModule : SpellModule
{
	public GameObject aoeToSpawnOnImpact;
	public float impactRadius = 3.5f;
	[SerializeField] LayerMask layerToRaycastOn;
	public AnimationCurve progressionCurve;
	Vector3 jumpPosStart, jumpPosEnd;
	CirclePreview myPreviewRange, myPreviewImpact;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		myPreviewRange = PreviewManager.Instance.GetCirclePreview(transform);
		myPreviewImpact = PreviewManager.Instance.GetCirclePreview(transform);
		myPreviewRange.Init(spell.range, CirclePreview.circleCenter.center, transform.position);
		myPreviewImpact.Init(impactRadius, CirclePreview.circleCenter.center, transform.position);
		HidePreview(Vector3.zero);
	}

	public override void TryCanalysing ( Vector3 _toAnnounce )
	{
		if(canStartCanalisation() && willResolve)
		{
			myPlayerModule.AddState(En_CharacterState.Intangenbility);
			myPlayerModule.AddState(En_CharacterState.Root);
			myPlayerModule.AddState(En_CharacterState.StopInterpolate);
			jumpPosStart = transform.position;
			jumpPosEnd = transform.position + myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(myPlayerModule.mousePos(), transform.position), 0, spell.range);
			jumpPosEnd.y = 0;
			jumpPosEnd = myPlayerModule.movementPart.FreeLocation(jumpPosEnd,Vector3.Distance(jumpPosEnd, transform.position));
		}
	
		base.TryCanalysing(_toAnnounce);
	}

	protected override void AnonceSpell ( Vector3 _toAnnounce )
	{
		base.AnonceSpell(_toAnnounce);
		NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeToSpawnOnImpact.gameObject), jumpPosEnd, transform.eulerAngles, 1);
		LocalPoolManager.Instance.SpawnNewAOEInNetwork(myPlayerModule.mylocalPlayer.myPlayerId, jumpPosEnd, impactRadius, spell.anonciationTime);
	}

	protected override void ResolveSpell ()
	{
		myPlayerModule.RemoveState(En_CharacterState.Intangenbility);
		myPlayerModule.RemoveState(En_CharacterState.Root);
		base.ResolveSpell();
	}

	public override void Interrupt ( bool isInterrupted = false )
	{
		myPlayerModule.RemoveState(En_CharacterState.StopInterpolate);
		base.Interrupt();
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();

		Vector3 posToJumpTo = transform.position + myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(myPlayerModule.mousePos(), transform.position), 0, spell.range);
		myPreviewImpact.Init(impactRadius, CirclePreview.circleCenter.center, posToJumpTo);
		myPreviewRange.Init(spell.range, CirclePreview.circleCenter.center, transform.position);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())

		{
			myPreviewRange.gameObject.SetActive(true);
			myPreviewImpact.gameObject.SetActive(true);
		}
		base.ShowPreview(mousePos);
	}

	protected override void HidePreview ( Vector3 _posToHide )
	{
		myPreviewRange.gameObject.SetActive(false);
		myPreviewImpact.gameObject.SetActive(false);
		base.HidePreview(_posToHide);
	}

	protected override void Update ()
	{
		base.Update();
		if(anonciated & !resolved)
		{
			Vector3 _posToSet = jumpPosStart + (jumpPosEnd - jumpPosStart) * progressionCurve.Evaluate((currentTimeCanalised - (spell.canalisationTime - spell.anonciationTime)) / spell.anonciationTime);

			transform.position = Vector3.Lerp(transform.position, new Vector3(_posToSet.x, 0, _posToSet.z), Time.deltaTime * 10) ;
		}
	}

	public override void ThrowbackEndFeedBack ()
	{
		myPlayerModule.mylocalPlayer.myAnimController.animator.gameObject.transform.localPosition = Vector3.zero;
		base.ThrowbackEndFeedBack();
	}
}
