using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
    [TabGroup("AutokillParameters")]  public float mylifeTime;
    [TabGroup("AutokillParameters")]  public float myLivelifeTime;
    [TabGroup("AutokillParameters")] [SerializeField] GameObject meshBlue;
    [TabGroup("AutokillParameters")] [SerializeField] GameObject meshRed;

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
                meshRed.SetActive(true);
                break;

            case Team.blue:
                meshBlue.SetActive(true);
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
        meshBlue.SetActive(false);
        meshRed.SetActive(false);

        if (this.GetComponent<NetworkedObject>().GetIsOwner())
        {
            NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
        }
    }

    protected virtual void FixedUpdate()
	{
        myLivelifeTime -= Time.fixedDeltaTime;

        if (myLivelifeTime <= 0)
        {

            Destroy();
        }
    }
}
