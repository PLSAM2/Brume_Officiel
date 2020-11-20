using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
    [HideInInspector] public KillLifeTime mylifeTimeInfos = new KillLifeTime();
    [HideInInspector] public KillLifeTime myLivelifeTimeInfos = new KillLifeTime();
    [Header("HideAtTheEndOfLife")]
    [SerializeField] GameObject mesh;
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
        myLivelifeTimeInfos.myLifeTime = mylifeTimeInfos.myLifeTime;
        print("Live" +myLivelifeTimeInfos.myLifeTime);
        mesh.SetActive(true);
        myNetworkObject = GetComponent<NetworkedObject>();
    }

    protected virtual void Destroy ()
    {
        mesh.SetActive(false);

        if (this.GetComponent<NetworkedObject>().GetIsOwner())
        {
            NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
        }
    }

    protected virtual void FixedUpdate()
	{
        myLivelifeTimeInfos.myLifeTime -= Time.fixedDeltaTime;

        if (myLivelifeTimeInfos.myLifeTime <= 0)
        {
            Destroy();
        }
    }
}
