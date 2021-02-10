using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class JumpModule : SpellModule
{
	public GameObject aoeToSpawnOnImpact;
	public float impactRadius = 5;
	[SerializeField] LayerMask layerToRaycastOn;
	Vector3 posToJumpOn;
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

	public override void StartCanalysing ( Vector3 _toAnnounce )
	{
		posToJumpOn = transform.position + myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(myPlayerModule.mousePos(), transform.position), 0, spell.range);
		base.StartCanalysing(_toAnnounce);
	}

	protected override void ResolveSpell ()
	{
		myPlayerModule.AddState(En_CharacterState.Integenbility);
		myPlayerModule.AddState(En_CharacterState.Root);
		transform.DOMove(new Vector3(posToJumpOn.x, 0, posToJumpOn.z), spell.throwBackDuration);
		base.ResolveSpell();
	}

	public override void Interrupt ()
	{
		myPlayerModule.RemoveState(En_CharacterState.Integenbility);
		myPlayerModule.RemoveState(En_CharacterState.Root);
		NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeToSpawnOnImpact.gameObject), transform.position, transform.eulerAngles, 1);
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
}
