using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class AutoKill : MonoBehaviour
{
    public KillLifeTime mylifeTimeInfos = new KillLifeTime();
    [ReadOnly] public KillLifeTime myLivelifeTimeInfos = new KillLifeTime();
    [SerializeField] GameObject mesh;


    protected virtual void OnEnable ()
    {
        myLivelifeTimeInfos.myLifeTime = mylifeTimeInfos.myLifeTime;
        mesh.SetActive(true);
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
