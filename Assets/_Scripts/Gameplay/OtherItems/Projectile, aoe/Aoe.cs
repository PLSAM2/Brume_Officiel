using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using DG.Tweening;

public class Aoe : AutoKill
{
	[TabGroup("AoeParameters")] public Sc_Aoe localTrad;
	bool asDealtFinal = false;
	LayerMask layer;
	public bool adaptiveRange = true;

	protected override void Awake ()
	{
		mylifeTime = localTrad.rules.durationOfTheAoe;
		layer = LayerMask.GetMask("Character");
	}
	public override void Init ( GameData.Team ownerTeam )
	{
		base.Init(ownerTeam);

		if (isOwner)
		{
			if (localTrad.rules.damagesToDealOnDuration.damageHealth != 0 || localTrad.rules.damagesToDealOnDuration.movementToApply != null)
				DealDamagesInRange(localTrad.rules.damagesToDealOnImpact);
			else
				DealDamagesInRange(localTrad.rules.damagesToDealOnImpact, false);

		}
	}

	IEnumerator CustomUpdate ()
	{
		yield return new WaitForSeconds(.2f);
		DealDamagesInRange(localTrad.rules.damagesToDealOnDuration);
	}

	void DealDamagesInRange ( DamagesInfos _damages, bool _boucle = true )
	{
		Collider[] _allhits;

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2, Quaternion.identity, layer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, layer);

		foreach (Collider _coll in _allhits)
		{
			Damageable _damageable = _coll.GetComponent<Damageable>();
			if (_damageable != null && !_damageable.IsInMyTeam(myteam))
			{
				float _percentageOfTheMovement = 1;

				if (adaptiveRange)
				{
					if (localTrad.rules.isBox)
					{
						if (_damages.movementToApply.isGrab)
							_percentageOfTheMovement = ((Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z) / 2);
						else
							_percentageOfTheMovement = (1 - ((Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z) / 2));
					}
					else
					{
						print("i m not a box");
						if (_damages.movementToApply.isGrab)
							_percentageOfTheMovement = (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius);
						else
							_percentageOfTheMovement = (1 - (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius));
					}
				}

				print(_percentageOfTheMovement);
				_damageable.DealDamages(_damages, transform.position, GameManager.Instance.currentLocalPlayer.myPlayerId, false, false, false, _percentageOfTheMovement);
			}
		}

		if (_boucle)
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
			if (localTrad.rules.finalDamages.damageHealth != 0 || localTrad.rules.finalDamages.movementToApply != null)
				DealDamagesInRange(localTrad.rules.finalDamages, false);
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