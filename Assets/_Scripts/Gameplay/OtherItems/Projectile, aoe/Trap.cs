using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trap : AutoKill
{
	public GameObject objectToSpawn;
	NetworkedObject myNetworkedObject;
	public float radiusOfTheTrap;


	public override void Init ( GameData.Team ownerTeam, float _percentageOfLifeTime = 1 )
	{
		if (isOwner)
		{
			Collider[] _hits = Physics.OverlapSphere(transform.position, radiusOfTheTrap, 8);

			foreach(Collider _hit in _hits)
			{
				Damageable _damageable = _hit.GetComponent<Damageable>();
				if (!_damageable.IsInMyTeam(myteam))
				{
					ActivateTrap();
					break;
				}
			}
			
		}
		base.Init(ownerTeam, _percentageOfLifeTime);
	}

	private void OnTriggerEnter ( Collider other )
	{
		if (isOwner)
		{
			Damageable _damageable = other.GetComponent<Damageable>();
			if (_damageable != null)
				if (!_damageable.IsInMyTeam(myteam))
				{
					ActivateTrap();
				}
		}
	}

	void ActivateTrap ()
	{

		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(objectToSpawn), transform.position, transform.rotation.eulerAngles);
		Destroy(true);
	}
}
