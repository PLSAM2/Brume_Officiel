using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fx : MonoBehaviour
{
    public bool isVisible = false;
    public List<GameObject> objToHide = new List<GameObject>();

    private void OnEnable()
    {
        GameManager.Instance.allFx.Add(this);

        bool display = IsVisible();

        foreach (GameObject obj in objToHide)
        {
            obj.SetActive(display);
        }

        isVisible = display;
    }

    bool IsVisible()
    {
        Collider[] targetsInViewRadius = Physics.OverlapSphere(transform.position, 20);

        for (int i = 0; i < targetsInViewRadius.Length; i++)
        {
            if(targetsInViewRadius[i].gameObject.layer != 7) { continue; }

            Transform target = targetsInViewRadius[i].transform;
            Vector3 dirToTarget = (target.position - transform.position).normalized;

            float dstToTarget = Vector3.Distance(transform.position, target.position);
            if (Physics.Raycast(transform.position, dirToTarget, dstToTarget))
            {
                return true;
            }
        }

        return false;
    }

    private void OnDisable()
    {
        GameManager.Instance.allFx.Remove(this);
        GameManager.Instance.allFx.RemoveAll(x => x == null);
    }
}
