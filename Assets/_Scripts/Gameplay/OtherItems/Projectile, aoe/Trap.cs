using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trap : AutoKill
{
	public float lifeTime;
	public GameObject objectToSpawn;
	NetworkedObject myNetworkedObject;
	float radiusOfTheTrap;
	private void Start ()
	{
		radiusOfTheTrap = GetComponent<SphereCollider>().radius;
	}

	public override void Init ( GameData.Team ownerTeam, float _percentageOfLifeTime = 1 )
	{
		mylifeTime = lifeTime;
		myLivelifeTime = mylifeTime;

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

		if(myteam != GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
		{
			meshBlue.SetActive(false);
			meshRed.SetActive(false);
		}
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
