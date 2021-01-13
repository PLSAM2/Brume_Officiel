using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
	[HideInInspector] [TabGroup("AutokillParameters")] public float mylifeTime;
	[HideInInspector] [TabGroup("AutokillParameters")] public float myLivelifeTime;
	[TabGroup("AutokillParameters")] public GameObject meshBlue;
	[TabGroup("AutokillParameters")] public GameObject meshRed;

	[HideInInspector] public Team myteam;
	[HideInInspector] public NetworkedObject myNetworkObject;
	[HideInInspector] public bool isOwner = false;

	[SerializeField] AudioClip spawnSound;

	protected virtual void Awake ()
	{
		myNetworkObject = GetComponent<NetworkedObject>();
	}

	public virtual void Init ( Team ownerTeam )
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
			AudioManager.Instance.Play3DAudio(spawnSound, transform.position);
		}
	}

	protected virtual void OnEnable ()
	{
		myLivelifeTime = mylifeTime;
	}

	protected virtual void Destroy ()
	{
		meshBlue.gameObject.SetActive(false);
		meshRed.gameObject.SetActive(false);

		if (this.GetComponent<NetworkedObject>().GetIsOwner())
		{
			NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
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
