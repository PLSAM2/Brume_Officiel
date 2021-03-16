using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnFxInPool : MonoBehaviour
{
    [SerializeField] ushort index;
    [SerializeField] float time = 3;

    [SerializeField] NetworkedObject myNetworkObj;

    [SerializeField] Transform objToFollow;

    private void Awake()
    {
        myNetworkObj.OnSpawnObj += OnSpawn;

        if(objToFollow == null)
        {
            objToFollow = transform;
        }
    }

    public void OnSpawn()
    {
        LocalPoolManager.Instance.SpawnNewGenericInLocal(index, objToFollow, 0, 1, time);
    }

    private void OnDestroy()
    {
        myNetworkObj.OnSpawnObj -= OnSpawn;
    }
}
