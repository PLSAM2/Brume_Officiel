using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnDynamicWalls : MonoBehaviour
{
    public List<Animator> doorAnimator = new List<Animator>();
    public List<Animator> brumeZone = new List<Animator>();


    public void SetDoorState(bool _state)
    {
        foreach (Animator a in doorAnimator)
        {
            a.SetBool("state", _state);
        }

        foreach (Animator a in brumeZone)
        {
            a.SetBool("state", _state);
        }
    }
}
