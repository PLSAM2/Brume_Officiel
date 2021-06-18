using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
	[TabGroup("AutokillParameters")] public float mylifeTime;
	[TabGroup("AutokillParameters")] [HideInInspector] public float myLivelifeTime;
	[TabGroup("AutokillParameters")] public bool isUsingTeamMesh = true;
	[TabGroup("AutokillParameters")] [ShowIf("isUsingTeamMesh")] public GameObject meshBlue;
	[TabGroup("AutokillParameters")] [ShowIf("isUsingTeamMesh")] public GameObject meshRed;
	[HideInInspector] public Team myteam;
	[HideInInspector] public NetworkedObject myNetworkObject;
	[HideInInspector] public bool isOwner = false;
	[SerializeField] AudioClip spawnSound;

	protected virtual void Awake ()
	{
		myNetworkObject = GetComponent<NetworkedObject>();

		if (isUsingTeamMesh)
		{
			meshBlue.gameObject.SetActive(false);
			meshRed.gameObject.SetActive(false);
		}
	}

	public virtual void Init ( Team ownerTeam, float _percentageOfLifeTime = 1 )
	{
		myLivelifeTime = mylifeTime;
		myNetworkObject = GetComponent<NetworkedObject>();
		isOwner = myNetworkObject.GetIsOwner();
		myteam = ownerTeam;

		if (isUsingTeamMesh)
		{
			DisplayMesh();
		}

		if (spawnSound != null)
		{
			AudioManager.Instance.Play3DAudio(spawnSound, transform.position, myNetworkObject.GetItemID(), false);
		}
	}

	protected virtual void DisplayMesh ()
	{
		if (!GameFactory.IsOnMyTeam(myNetworkObject.GetOwnerID()))
			meshRed.gameObject.SetActive(true);
		else
			meshBlue.gameObject.SetActive(true);

	}

	protected virtual void OnDisable ()
	{
		myLivelifeTime = mylifeTime;
	}

	public virtual void Destroy ( bool _spawnAoe = false )
	{
		if (isUsingTeamMesh)
		{
			meshBlue.gameObject.SetActive(false);
			meshRed.gameObject.SetActive(false);
		}

		if (myNetworkObject.GetIsOwner())
		{
			NetworkObjectsManager.Instance.DestroyNetworkedObject(myNetworkObject.GetItemID());
		}
	}

	protected virtual void Update ()
	{
		myLivelifeTime -= Time.deltaTime;

		if (myLivelifeTime <= 0)
		{

			Destroy();
		}
	}
}
