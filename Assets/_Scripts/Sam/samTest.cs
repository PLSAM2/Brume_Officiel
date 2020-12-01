using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    //coroutine 1
    IEnumerator DoSomething1()
    {
        while (true)
        {
            yield return new WaitForSeconds(1.0f);
        }
    }

    //coroutine 2
    IEnumerator DoSomething2()
    {
        while (true)
        {
            yield return new WaitForSeconds(1.5f);
        }
    }

    void Start()
    {
        StartCoroutine("DoSomething1");
        StartCoroutine("DoSomething2");
    }

    void Update()
    {
        if (Input.GetKeyDown("space"))
        {
            StopAllCoroutines();
            print("Stopped all Coroutines: " + Time.time);
        }
    }
}
