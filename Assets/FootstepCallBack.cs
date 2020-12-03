using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepCallBack : MonoBehaviour
{
    [SerializeField] FootstepAudio myFootstep;

    public void OnAnimRun()
    {
        myFootstep.OnAnimRun();
    }
}
