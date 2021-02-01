using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trap : AutoKill
{
	public float lifeTime;
	public GameObject objectToSpawn;
	NetworkedObject myNetworkedObject;

	public override void Init ( GameData.Team ownerTeam, float _percentageOfLifeTime = 1 )
	{
		mylifeTime = lifeTime;
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
					NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(objectToSpawn), transform.position, transform.rotation.eulerAngles);
				}
		}
	}
}
