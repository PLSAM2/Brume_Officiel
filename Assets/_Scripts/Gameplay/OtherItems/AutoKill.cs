﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class AutoKill : MonoBehaviour
{
    [TabGroup("AutokillParameters")] [HideInInspector] public float mylifeTime;
    [TabGroup("AutokillParameters")] [HideInInspector] public float myLivelifeTime;
    [TabGroup("AutokillParameters")] [SerializeField] GameObject meshBlue;
    [TabGroup("AutokillParameters")] [SerializeField] GameObject meshRed;

    [HideInInspector] public Team myteam;
    [HideInInspector] public NetworkedObject myNetworkObject;
    [HideInInspector] public bool isOwner = false;

	protected virtual void Awake ()
	{
        myNetworkObject = GetComponent<NetworkedObject>();
    }

    public virtual void Init ( Team ownerTeam )
    {
        myteam = ownerTeam;
        isOwner = myNetworkObject.GetIsOwner();
        switch (myteam)
        {
            case Team.red:
                meshRed.SetActive(true);
                break;

            case Team.blue:
                meshBlue.SetActive(true);
                break;
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
