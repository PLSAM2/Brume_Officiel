using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoDisable : MonoBehaviour
{
    public void Init(float _time)
    {
        print(_time);
        StartCoroutine(WaitToDisable(_time));
    }

    IEnumerator WaitToDisable(float _time)
    {
        yield return new WaitForSeconds(_time);
        gameObject.SetActive(false);
    }
}
