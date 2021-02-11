using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class FxFollow : MonoBehaviour
{
    public Transform target;

    public UnityEvent OnObjSpawn;
    public UnityEvent OnObjDestroy;

    private void OnEnable()
    {
        OnObjSpawn?.Invoke();
    }

    void Update()
    {
        if (target)
        {
            transform.position = target.position;

            if (!target.gameObject.activeSelf)
            {
                target = null;
            }
        }
    }

    private void OnDisable()
    {
        target = null;
        OnObjDestroy?.Invoke();
    }
}
