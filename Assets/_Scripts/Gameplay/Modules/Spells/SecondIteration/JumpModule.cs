using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpModule : SpellModule
{
	public Aoe aoeToSpawnOnImpact;
	LayerMask layerToRaycastOn;
	Vector3 _posToJumpOn;
	public override void StartCanalysing ( Vector3 _toAnnounce )
	{
		base.StartCanalysing(_toAnnounce);
		myPlayerModule.AddState(En_CharacterState.Integenbility);
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		myPlayerModule.RemoveState(En_CharacterState.Integenbility);
	}

	protected override bool canBeCast ()
	{
		Ray ray;
		RaycastHit hit;

		ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		if (Physics.Raycast(ray, out hit, 300, layerToRaycastOn))
		{
			if()

			_posToJumpOn = hit.point;



			
		}

		return base.canBeCast();
	}
}
