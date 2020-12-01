using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpearFx : MonoBehaviour
{
    [SerializeField] GameObject ExplosionPrefab;

    List<GameObject> oldExplosions = new List<GameObject>();

    float currentSize = 0;

    private void Start()
    {
        currentSize = Mathf.Floor(transform.localScale.z);

        SupprOld();
        StartCoroutine(SpawnSpear());
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(Mathf.Floor(transform.localScale.z) != currentSize)
        {
            currentSize = Mathf.Floor(transform.localScale.z);

            SupprOld();
            StartCoroutine(SpawnSpear());
        }
    }

    IEnumerator SpawnSpear()
    {
        float time = 0.5f / currentSize;

        for (int i = 0; i < currentSize; i++)
        {
            GameObject explo = Instantiate(ExplosionPrefab, transform.position, Quaternion.identity);
            explo.transform.parent = transform;
            explo.transform.localPosition = new Vector3(0, 0, (i + 1) * 0.15f);
            oldExplosions.Add(explo);

            yield return new WaitForSeconds(time);
        }
    }

    void SupprOld()
    {
        foreach(GameObject obj in oldExplosions)
        {
            Destroy(obj);
        }
    }
}
