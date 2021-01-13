using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HurtingDash : SpellModule
{
	[SerializeField] float hurtingBoxWidth = .8f;
	public DamagesInfos damages;
	bool hasTouched = false;
	public float cooldownReduction;
	[SerializeField] HurtingBox hurtBox;

	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		hurtBox.ResetHitbox();
		hasTouched = false;
		base.StartCanalysing(_BaseMousePos);
	}

	protected override void Resolution ()
	{
		hurtBox.gameObject.SetActive(true);

		myPlayerModule.forcedMovementInterrupted += Interrupt;

		gameObject.layer = 13;

		base.Resolution();
	}

	public override void Interrupt ()
	{
		hurtBox.gameObject.SetActive(false);

		gameObject.layer = 8;

		myPlayerModule.forcedMovementInterrupted -= Interrupt;

		base.Interrupt();
	}

	public void TouchedAnEnemy ( PlayerModule _hitHostile )
	{
		Damageable _hit = _hitHostile.GetComponent<Damageable>();

		if (_hit != null && !_hit.IsInMyTeam(myPlayerModule.teamIndex))
		{
			_hit.DealDamages(damages, transform.position, myPlayerModule.mylocalPlayer.myPlayerId);

			if (!hasTouched)
			{
				hasTouched = true;
				ReduceCooldown(cooldownReduction);
			}
		}
	}
}