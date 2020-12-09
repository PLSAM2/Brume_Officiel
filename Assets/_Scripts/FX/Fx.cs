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

        foreach(GameObject obj in objToHide)
        {
            obj.SetActive(false);
        }
    }

    private void OnDisable()
    {
        GameManager.Instance.allFx.Remove(this);
        GameManager.Instance.allFx.RemoveAll(x => x == null);
    }
}
