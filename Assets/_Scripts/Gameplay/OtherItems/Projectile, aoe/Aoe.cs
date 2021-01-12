using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class Aoe : AutoKill
{
	[TabGroup("AoeParameters")] public Sc_Aoe localTrad;
	bool asDealtFinal = false;
	LayerMask layer;

	protected override void Awake ()
	{
		mylifeTime = localTrad.rules.durationOfTheAoe;
		layer = LayerMask.GetMask("Character");
	}
	public override void Init ( GameData.Team ownerTeam )
	{
		base.Init(ownerTeam);

		if (isOwner)
			DealDamagesInRange(localTrad.rules.damagesToDealOnImpact);
	}

	IEnumerator CustomUpdate ()
	{
		yield return new WaitForSeconds(.2f);
		DealDamagesInRange(localTrad.rules.damagesToDealOnDuration);
	}

	void DealDamagesInRange ( DamagesInfos _damages )
	{
		Collider[] _allhits;

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2, Quaternion.identity, layer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, layer);

		foreach (Collider _coll in _allhits)
		{
			Damageable _damageable = _coll.GetComponent<Damageable>();
			if (_damageable != null)
				_damageable.DealDamages(_damages, transform.position, GameManager.Instance.currentLocalPlayer.myPlayerId);
		}

		StartCoroutine(CustomUpdate());
	}

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();
		if (myLivelifeTime <= localTrad.rules.timeBeforeFinalDisparition &&
			localTrad.rules.timeBeforeFinalDisparition != 0 &&
				!asDealtFinal)
		{
			StopAllCoroutines();
			asDealtFinal = true;
			DealDamagesInRange(localTrad.rules.finalDamages);
		}
	}

	private void OnDrawGizmosSelected ()
	{
		if (localTrad.rules.isBox)
			Gizmos.DrawCube(transform.position, localTrad.rules.boxDimension);
		else
			Gizmos.DrawSphere(transform.position, localTrad.rules.aoeRadius);
	}

	protected override void Destroy ()
	{
		StopAllCoroutines();
		base.Destroy();
	}

	protected override void OnEnable ()
	{
		base.OnEnable();
		asDealtFinal = false;
	}
}