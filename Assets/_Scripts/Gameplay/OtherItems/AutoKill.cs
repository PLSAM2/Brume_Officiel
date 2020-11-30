using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
    [HideInInspector] public float mylifeTime;
    [HideInInspector] public float myLivelifeTime;
    [Header("HideAtTheEndOfLife")]
    [SerializeField] GameObject meshBlue;
    [SerializeField] GameObject meshRed;

    [HideInInspector] public Team myteam;
    [HideInInspector] public NetworkedObject myNetworkObject;
    [HideInInspector] public bool isOwner = false;

    public virtual void Init ( Team ownerTeam )
    {
        myteam = ownerTeam;
        isOwner = GetComponent<NetworkedObject>().GetIsOwner();
    }

    protected virtual void OnEnable ()
    {
        myLivelifeTime = mylifeTime;

        switch (myteam)
        {
            case Team.red:
                meshRed.SetActive(true);
                break;

            case Team.blue:
                meshBlue.SetActive(true);
                break;
        }
        myNetworkObject = GetComponent<NetworkedObject>();
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
