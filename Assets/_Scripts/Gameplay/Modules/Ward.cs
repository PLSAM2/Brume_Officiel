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

    }
    IEnumerator WardLifeTime()
    {
        yield return new WaitForSeconds(lifeTime);
        DestroyWard();

    }



}
