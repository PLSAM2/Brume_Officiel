using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnDynamicWalls : MonoBehaviour
{
    public List<Animator> doorAnimator = new List<Animator>();
    public List<GameObject> noMozeZones = new List<GameObject>();


    public void SetDoorState(bool _state)
    {
        foreach (Animator a in doorAnimator)
        {
            a.SetBool("state", _state);
        }

        foreach (GameObject go in noMozeZones)
        {
            go.SetActive(_state);
        }
    }
}
