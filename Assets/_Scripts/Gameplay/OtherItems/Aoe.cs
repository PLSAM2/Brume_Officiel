using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class Aoe : AutoKill
{
	[TabGroup("AoeParameters")] public Sc_Aoe localTrad;

	protected override void Awake ()
	{
		mylifeTime = localTrad.rules.durationOfTheAoe;
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

	void DealDamagesInRange (DamagesInfos _damages)
	{
		Collider[] _allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, 1 << 8);
		List<GameObject> _allChecked = new List<GameObject>();

		foreach(Collider _coll in _allhits)
		{
			LocalPlayer player = _coll.GetComponent<LocalPlayer>();

			if (player.myPlayerModule.teamIndex != GameFactory.GetLocalPlayerObj().myPlayerModule.teamIndex && !_allChecked.Contains(_coll.gameObject))
			{
				_allChecked.Add(_coll.gameObject);

				player.DealDamages(_damages, transform.position);
			}
		}

		StartCoroutine(CustomUpdate());
	}

	private void OnDrawGizmosSelected ()
	{
		Gizmos.DrawSphere(transform.position, localTrad.rules.aoeRadius);
	}

	protected override void Destroy ()
	{
		StopAllCoroutines();
		base.Destroy();
	}
}