using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ward : MonoBehaviour
{
    public float lifeTime = 60;
    public void Landed()
    {
        StartCoroutine(WardLifeTime());
    }


    public void DestroyWard()
    {
        this.gameObject.SetActive(false);
    }
    IEnumerator WardLifeTime()
    {
        yield return new WaitForSeconds(lifeTime);
        DestroyWard();

    }



}
