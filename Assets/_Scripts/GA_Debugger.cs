using Sirenix.OdinInspector;
using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;

public class GA_Debugger : SerializedMonoBehaviour
{
    [Header("Shader Debugger")]
    public bool sw = false;
    public List<Shader> shader = new List<Shader>();
    public string property;


    public void InOutBrumeDebug()
    {
        MeshRenderer[] allObjects = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer R in allObjects)
        {
            if (shader.Contains(R.material.shader))
            {
                if (sw)
                {
                    R.material.SetFloat(property, 1);
                }
                else
                {
                    R.material.SetFloat(property, 0);
                }
            }
        }

        sw = !sw;
    }


}
