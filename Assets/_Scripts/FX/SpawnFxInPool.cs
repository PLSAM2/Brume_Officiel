using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnFxInPool : MonoBehaviour
{
    [SerializeField] ushort index;
    [SerializeField] float time = 3;

    [SerializeField] NetworkedObject myNetworkObj;

    private void Awake()
    {
        myNetworkObj.OnSpawnObj += OnSpawn;
    }

    public void OnSpawn()
    {
        LocalPoolManager.Instance.SpawnNewGenericInLocal(index, transform, 0, 1, time);
    }

    private void OnDestroy()
    {
        myNetworkObj.OnSpawnObj -= OnSpawn;
    }
}
