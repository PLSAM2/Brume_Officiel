using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoDisable : MonoBehaviour
{
    public float time = 1;

    private void Start()
    {
        StartCoroutine(WaitToDisable());
    }

    IEnumerator WaitToDisable()
    {
        yield return new WaitForSeconds(time);
        gameObject.SetActive(false);
    }
}
