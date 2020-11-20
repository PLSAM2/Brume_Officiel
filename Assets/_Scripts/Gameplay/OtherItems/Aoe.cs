using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
using Sirenix.OdinInspector;

[InlineEditor]
public class Aoe : AutoKill
{
	public Team myteam;
	public NetworkedObject myNetworkObject;
	[SerializeField] SphereCollider _myColl;
	[SerializeField] DamagesInfos damagesToDealOnImpact;
	[SerializeField] DamagesInfos damagesToDealOnStay;

	private void Start ()
	{
		_myColl = GetComponent<SphereCollider>();
		myNetworkObject = GetComponent<NetworkedObject>();
	}

	protected override void OnEnable ()
	{
		base.OnEnable();
		myteam = myNetworkObject.GetOwner().playerTeam;

		RaycastHit[] _allhits = Physics.SphereCastAll(transform.position, _myColl.radius, Vector3.zero, 0, 1 << 8);
		foreach(RaycastHit _hit in _allhits)
		{
			_hit.collider.GetComponent<LocalPlayer>().DealDamages(damagesToDealOnImpact);
		}
	}

	private void OnTriggerEnter ( Collider other )
	{
		if (myNetworkObject.GetIsOwner())
		{
			LocalPlayer _player = other.GetComponent<LocalPlayer>();
			if (_player != null)
			{
				print(_player);
				_player.DealDamages(damagesToDealOnStay);


				if (myLivelifeTimeInfos.myLifeTime <= .25f)
					_player.DealDamages(damagesToDealOnImpact);
				
			}
		}
	}

	private void OnTriggerExit ( Collider other )
	{
		LocalPlayer _player = other.GetComponent<LocalPlayer>();
		if (_player != null)
		{
			_player.myPlayerModule.StopStatus(damagesToDealOnStay.statusToApply[0].effect.forcedKey);
		}
	}
}