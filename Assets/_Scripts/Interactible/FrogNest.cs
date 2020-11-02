using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrogNest : MonoBehaviour
{
    public Frog frogObj;
    public float respawnTime;

    private void Start()
    {
        frogObj.nest = this;
    }

    public void SpawnFrog()
    {
        frogObj.gameObject.SetActive(true);
    }

    public void FrogPicked()
    {
        frogObj.capturingPlayerModule.interactiblesClose.Remove(frogObj);
        frogObj.gameObject.SetActive(false);

        StartCoroutine(WaitForRespawn());
    }

    IEnumerator WaitForRespawn()
    {
        yield return new WaitForSeconds(respawnTime);
        SpawnFrog();
    }

}
