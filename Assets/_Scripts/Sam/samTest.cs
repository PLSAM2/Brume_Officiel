using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        print("enter");
    }

    private void OnTriggerExit(Collider other)
    {
        print("exit");
    }
}
