using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
	[TabGroup("AutokillParameters")] [HideInInspector] public float mylifeTime;
	[TabGroup("AutokillParameters")] [HideInInspector] public float myLivelifeTime;
	[TabGroup("AutokillParameters")] public GameObject meshBlue;
	[TabGroup("AutokillParameters")] public GameObject meshRed;

	[HideInInspector] public Team myteam;
	[HideInInspector] public NetworkedObject myNetworkObject;
	[HideInInspector] public bool isOwner = false;

	[SerializeField] AudioClip spawnSound;

	protected virtual void Awake ()
	{
		myNetworkObject = GetComponent<NetworkedObject>();
		meshBlue.gameObject.SetActive(false);
		meshRed.gameObject.SetActive(false);

	}

	public virtual void Init ( Team ownerTeam, float _percentageOfLifeTime = 1 )
	{
		myNetworkObject = GetComponent<NetworkedObject>();

		isOwner = myNetworkObject.GetIsOwner();
		myteam = ownerTeam;
		switch (myteam)
		{
			case Team.red:
				meshRed.gameObject.SetActive(true);
				break;

			case Team.blue:
				meshBlue.gameObject.SetActive(true);
				break;
		}

		if (spawnSound)
		{
			AudioManager.Instance.Play3DAudio(spawnSound, transform.position, myNetworkObject.GetItemID(), false);
		}
	}

	protected virtual void OnDisable ()
	{
		myLivelifeTime = mylifeTime;
	}

	public virtual void Destroy (bool _spawnAoe = false)
	{
		meshBlue.gameObject.SetActive(false);
		meshRed.gameObject.SetActive(false);

		if (myNetworkObject.GetIsOwner())
		{
			NetworkObjectsManager.Instance.DestroyNetworkedObject(myNetworkObject.GetItemID());
		}
	}

	protected virtual void FixedUpdate ()
	{
		myLivelifeTime -= Time.fixedDeltaTime;

		if (myLivelifeTime <= 0)
		{

			Destroy();
		}
	}
}
