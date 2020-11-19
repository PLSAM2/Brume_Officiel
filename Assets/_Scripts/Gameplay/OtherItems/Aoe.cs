using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
using Sirenix.OdinInspector;

[InlineEditor]
public class Aoe : MonoBehaviour
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

	private void OnTriggerEnter ( Collider other )
	{
		
	}

	private void OnTriggerExit ( Collider other )
	{
		
	}

	public void OnEnable()
	{
		if(myNetworkObject.GetIsOwner())
		{
			RaycastHit[] _hits = Physics.SphereCastAll(transform.position, _myColl.radius, Vector3.zero, 0, 1 << 8);
			if (_hits.Length > 0)
			{
				foreach (RaycastHit _hit in _hits)
				{
					_hit.collider.GetComponent<LocalPlayer>().DealDamages(damagesToDealOnImpact);
				}
			}
		}
		
	}
}
