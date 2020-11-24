using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class Aoe : AutoKill
{
	[SerializeField] Sc_Spit localTrad;

	protected override void OnEnable ()
	{

		base.OnEnable();

		mylifeTime = localTrad.durationOfTheAoe;


		if (myNetworkObject.GetIsOwner())
			DealDamagesInRange(localTrad.damagesToDealOnImpact);
	}

	IEnumerator CustomUpdate ()
	{
		yield return new WaitForSeconds(.2f);
		DealDamagesInRange(localTrad.damagesToDealOnDuration);
	}

	void DealDamagesInRange (DamagesInfos _damages)
	{
		Collider[] _allhits = Physics.OverlapSphere(transform.position, localTrad.aoeRadius, 1 << 8);
		List<GameObject> _allChecked = new List<GameObject>();

		foreach(Collider _coll in _allhits)
		{
			LocalPlayer player = _coll.GetComponent<LocalPlayer>();

			if (player.myPlayerModule.teamIndex != GameManager.Instance.GetLocalPlayerObj().myPlayerModule.teamIndex && !_allChecked.Contains(_coll.gameObject))
			{
				_allChecked.Add(_coll.gameObject);
				player.DealDamages(_damages, transform.position);
			}
		}

		StartCoroutine(CustomUpdate());
	}

	private void OnDrawGizmosSelected ()
	{
		Gizmos.DrawSphere(transform.position, localTrad.aoeRadius);
	}

	protected override void Destroy ()
	{
		StopAllCoroutines();
		base.Destroy();
	}
}