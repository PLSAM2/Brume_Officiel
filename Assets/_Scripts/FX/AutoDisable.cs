using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoDisable : MonoBehaviour
{
    public bool setAtStart = false;
    public float time = 0;

    private void OnEnable()
    {
        if (setAtStart)
        {
            print("test");
            Init(time);
        }
    }

    public void Init(float _time)
    {
        StartCoroutine(WaitToDisable(_time));
    }

    IEnumerator WaitToDisable(float _time)
    {
        yield return new WaitForSeconds(_time);
        gameObject.SetActive(false);
    }
}
