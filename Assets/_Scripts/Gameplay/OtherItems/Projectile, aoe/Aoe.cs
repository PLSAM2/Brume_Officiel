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
		layer = LayerMask.GetMask("Character");
		mylifeTime = localTrad.rules.durationOfTheAoe;
		myLivelifeTime = mylifeTime;
	}
	public override void Init ( GameData.Team ownerTeam, float _LifePercentage )
	{
		base.Init(ownerTeam, _LifePercentage);

		if (isOwner)
		{
			if (localTrad.rules.damagesToDealOnDuration.damageHealth != 0 || localTrad.rules.damagesToDealOnDuration.movementToApply != null)
				DealDamagesInRange(localTrad.rules.damagesToDealOnImpact, true);
			else
				DealDamagesInRange(localTrad.rules.damagesToDealOnImpact, false);
		}
	}

	IEnumerator CustomUpdate ()
	{
		yield return new WaitForSeconds(.2f);
		DealDamagesInRange(localTrad.rules.damagesToDealOnDuration);
	}

	protected void DealDamagesInRange ( DamagesInfos _damages, bool _boucle = true )
	{
		foreach (Collider _damageable in enemiesHit())
		{
			print("I deal");

			float _percentageOfStrength = 1;

			if (_damages.movementToApply != null)
			{
				if (localTrad.rules.isBox)
				{
					if (_damages.movementToApply.isGrab)
						_percentageOfStrength = Mathf.Abs(transform.position.x - _damageable.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _damageable.transform.position.z) / localTrad.rules.boxDimension.z / 2;
					else
						_percentageOfStrength = (1 - (Mathf.Abs(transform.position.x - _damageable.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _damageable.transform.position.z) / localTrad.rules.boxDimension.z) / 2);

				}
				else
				{
					if (_damages.movementToApply.isGrab)
						_percentageOfStrength = (Vector3.Distance(transform.position, _damageable.transform.position) / localTrad.rules.aoeRadius);

					else
						_percentageOfStrength = (1 - (Vector3.Distance(transform.position, _damageable.transform.position) / localTrad.rules.aoeRadius));
				}
			}


			_damageable.GetComponent<Damageable>().DealDamages(_damages, transform.position, GameManager.Instance.currentLocalPlayer.myPlayerId, false, false, _percentageOfStrength);

			if (_boucle)
				StartCoroutine(CustomUpdate());
		}

	}

	protected Collider[] enemiesHit ()
	{
		Collider[] _allhits;
		List<Collider> _allHitChecked = new List<Collider>();

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2 + Vector3.up * 8, Quaternion.identity, layer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, layer);

		foreach (Collider _coll in _allhits)
		{
			Damageable _damageable = _coll.GetComponent<Damageable>();
			if (_damageable != null && !_damageable.IsInMyTeam(myteam))
			{
				_allHitChecked.Add(_coll);
			}
		}

		return _allHitChecked.ToArray();
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

	public override void Destroy ( bool _spawnAoe = false )
	{
		StopAllCoroutines();
		base.Destroy();
	}

	protected void OnEnable ()
	{
		asDealtFinal = false;
	}
}