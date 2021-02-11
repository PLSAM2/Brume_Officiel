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
	[TabGroup("AutokillParameters")] [ShowIf("isUsingTeamMesh")] public bool hideMeshToEnemyTeam = false;
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
		myNetworkObject = GetComponent<NetworkedObject>();
		isOwner = myNetworkObject.GetIsOwner();
		myteam = ownerTeam;

        if (isUsingTeamMesh)
        {
			if (hideMeshToEnemyTeam)
			{
				if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myteam))
					DisplayMesh();
			}
			else
				DisplayMesh();
		}

		if (spawnSound)
		{
			AudioManager.Instance.Play3DAudio(spawnSound, transform.position, myNetworkObject.GetItemID(), false);
		}
	}

	void DisplayMesh ()
	{
		switch (myteam)
		{
			case Team.red:
				meshRed.gameObject.SetActive(true);
				break;

			case Team.blue:
				meshBlue.gameObject.SetActive(true);
				break;
		}
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

	protected virtual void FixedUpdate ()
	{
		myLivelifeTime -= Time.fixedDeltaTime;

		if (myLivelifeTime <= 0)
		{

			Destroy();
		}
	}
}
