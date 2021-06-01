using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RiftDamageFx : MonoBehaviour
{
    [SerializeField] Fx myFx;

    [SerializeField] GameObject ExplosionPrefab;

    List<GameObject> oldExplosions = new List<GameObject>();

    float currentSize = 0;

    private void OnEnable()
    {
        currentSize = Mathf.Floor(transform.localScale.z);

        SupprOld();
        SpawnSpear();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(Mathf.Floor(transform.localScale.z) != currentSize)
        {
            currentSize = Mathf.Floor(transform.localScale.z);

            SupprOld();
            SpawnSpear();
        }
    }

    private void OnDisable()
    {
        SupprOld();
    }

    void SpawnSpear()
    {
        float time = 0.5f / currentSize;
        float startPos = 1 / currentSize;

        myFx.objToHide.RemoveAll(x => x == null);

        for (int i = 0; i < currentSize; i++)
        {
            GameObject explo = Instantiate(ExplosionPrefab, transform.position, Quaternion.identity);
            explo.transform.parent = transform;
            explo.transform.localPosition = new Vector3(0, 0, startPos);
            oldExplosions.Add(explo);

            myFx.objToHide.Add(explo);

            startPos += 1 / currentSize;
        }

        GameFactory.DoScreenShake(0.15f, 0.15f, transform.position);
    }

    void SupprOld()
    {
        foreach(GameObject obj in oldExplosions)
        {
            Destroy(obj);
        }
    }
}
