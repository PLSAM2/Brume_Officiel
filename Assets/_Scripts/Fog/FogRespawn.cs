using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogRespawn : MonoBehaviour
{
    public FieldOfView myFog;

    // Start is called before the first frame update
    void Start()
    {
        myFog.GenerateFowStatic();
    }
}
