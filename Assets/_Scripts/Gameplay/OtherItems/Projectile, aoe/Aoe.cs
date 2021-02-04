using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using DG.Tweening;

public class Aoe : AutoKill
{
	[TabGroup("AoeParameters")] public Sc_Aoe localTrad;
	bool asDealtFinal = false;
	LayerMask allyLayer, enemyLayer;
	public bool adaptiveRange = true;

	protected override void Awake ()
	{
		allyLayer = LayerMask.GetMask("CharacterIntengible") | LayerMask.GetMask("AlliedCharacter");
		enemyLayer = LayerMask.GetMask("Character");

		mylifeTime = localTrad.rules.durationOfTheAoe;
		myLivelifeTime = mylifeTime;
	}
	public override void Init ( GameData.Team ownerTeam, float _LifePercentage )
	{
		base.Init(ownerTeam, _LifePercentage);
		if (isOwner)
		{
			if (localTrad.rules.damagesToDealOnImpact.isUsable)
				DealDamagesInRange(localTrad.rules.damagesToDealOnImpact);

			if (localTrad.rules.impactAlly.isUsable)
				DealBuffInRange(localTrad.rules.impactAlly);
		}
	}

	IEnumerator CustomUpdate ()
	{
		yield return new WaitForSeconds(.2f);
		if (localTrad.rules.damagesToDealOnDuration.isUsable)
			DealDamagesInRange(localTrad.rules.damagesToDealOnDuration);

		if (localTrad.rules.durationAlly.isUsable)
			DealBuffInRange(localTrad.rules.durationAlly);
	}

	protected void DealDamagesInRange ( DamagesInfos _damages )
	{
		foreach (Collider _coll in enemiesTouched())
		{
			Damageable _damageable = _coll.GetComponent<Damageable>();

			Vector3 _posOfDealing = transform.position;

			if (_damageable != null)
			{
				float _percentageOfStrength = 1;

				if (_damages.movementToApply != null)
				{
					if (localTrad.rules.isBox)
					{
						if (_damages.movementToApply.isGrab)
							_percentageOfStrength = Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z / 2;
						else
							_percentageOfStrength = (1 - (Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z) / 2);

					}
					else
					{
						if (_damages.movementToApply.isGrab)
							_percentageOfStrength = (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius);

						else
							_percentageOfStrength = (1 - (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius));
					}

					if (localTrad.rules.useOwnerPos)
						_posOfDealing = GameManager.Instance.currentLocalPlayer.transform.position;
				}

				_damageable.DealDamages(_damages, _posOfDealing, GameManager.Instance.currentLocalPlayer.myPlayerId, false, false, _percentageOfStrength);
			}
		}
	}

	protected void DealBuffInRange ( DamagesInfos _buff )
	{
		foreach (Collider _coll in alliedTouched())
		{
			Damageable _damageable = _coll.GetComponent<Damageable>();

			Vector3 _posOfDealing = transform.position;

			if (_damageable != null && _damageable.IsInMyTeam(myteam))
			{
				float _percentageOfStrength = 1;

				if (_buff.movementToApply != null)
				{
					if (localTrad.rules.isBox)
					{
						if (_buff.movementToApply.isGrab)
							_percentageOfStrength = Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z / 2;
						else
							_percentageOfStrength = (1 - (Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z) / 2);

					}
					else
					{
						if (_buff.movementToApply.isGrab)
							_percentageOfStrength = (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius);

						else
							_percentageOfStrength = (1 - (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius));
					}


					if (localTrad.rules.useOwnerPos)
						_posOfDealing = GameManager.Instance.currentLocalPlayer.transform.position;
				}

				_damageable.DealDamages(_buff, _posOfDealing, GameManager.Instance.currentLocalPlayer.myPlayerId, false, false, _percentageOfStrength);
			}
		}
	}

	protected Collider[] enemiesTouched ()
	{
		Collider[] _allhits;

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2 + Vector3.up * 8, Quaternion.identity, enemyLayer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, enemyLayer);

		return _allhits;
	}

	protected Collider[] alliedTouched ()
	{
		Collider[] _allhits;

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2 + Vector3.up * 8, Quaternion.identity, allyLayer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, allyLayer);

		return _allhits;
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
			if (localTrad.rules.finalDamages.isUsable)
				DealDamagesInRange(localTrad.rules.finalDamages);

			if (localTrad.rules.finalAlly.isUsable)
				DealBuffInRange(localTrad.rules.finalAlly);
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
		if (isOwner)
			StartCoroutine(CustomUpdate());
	}

	protected override void OnDisable ()
	{
		base.OnDisable();
		StopAllCoroutines();
	}
}