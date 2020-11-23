using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    [SerializeField] Transform target;

    private void Update()
    {
        transform.LookAt(target);
        transform.localEulerAngles = new Vector3(0, transform.localEulerAngles.y, transform.localEulerAngles.z);
    }
}
