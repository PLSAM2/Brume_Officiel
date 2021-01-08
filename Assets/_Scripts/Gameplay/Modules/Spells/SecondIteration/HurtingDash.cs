using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HurtingDash : SpellModule
{
	[SerializeField] float hurtingBoxWidth = .8f;
	[SerializeField] float cooldownRefounded;
	public DamagesInfos damages;
	bool hasTouched = false, hasReset = false;
	[SerializeField] HurtingBox hurtBox;

	private void Start ()
	{
		hurtBox.myHurtingDash = this;
	}
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

		if (hasTouched && !hasReset)
		{
			myPlayerModule.reduceTargetCooldown?.Invoke(cooldownRefounded, actionLinked);
			hasReset = true;
		}
		else
			hasReset = false;

	}

	public void TouchedAnEnemy ( PlayerModule _hitHostile )
	{
		_hitHostile.GetComponent<Damageable>().DealDamages(damages, transform.position, myPlayerModule.mylocalPlayer.myPlayerId);
		hasTouched = true;
	}
}