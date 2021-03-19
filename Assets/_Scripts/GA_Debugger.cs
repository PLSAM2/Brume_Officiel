using Sirenix.OdinInspector;
using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;
using System.Linq;

public class GA_Debugger : SerializedMonoBehaviour
{
    private bool sw = false;
    [Header("Shader Debugger")]
    [TabGroup("Shader")] public List<Shader> shader = new List<Shader>();

    [TabGroup("Shader")] public string property;
    [TabGroup("Shader")] private float value = 0;
    [TabGroup("Shader")] public float shaderDebugLerpSpeed;
    public GameObject Brume;

    [TabGroup("Shader")]
    [Button("Shader debug")]
    public void InOutBrumeDebug()
    {

        foreach (Material R in diffMat)
        {
            if (sw)
            {
                R.SetFloat(property, value);
            }
            else
            {
                R.SetFloat(property, value);
            }
        }

        sw = !sw;
    }
    [TabGroup("Shader")]
    [Button("Shader debug")]
    public void Reset()
    {
        foreach (Material R in diffMat)
        {
            R.SetFloat(property, 0);
        }
    }

    [TabGroup("Material")] public List<Material> diffMat = new List<Material>();
    [Button("Mat debug")]
    public void MatDebug()
    {
        // berk
        MeshRenderer[] allObjects = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer R in allObjects)
        {
            if (R.sharedMaterial == null)
            {
                continue;
            }

            if (diffMat.Contains(R.sharedMaterial))
            {
                continue;
            }

            if (shader.Contains(R.sharedMaterial.shader))
            {
                diffMat.Add(R.sharedMaterial);
            }
        }

    }



    public void ActivateBrume()
    {
        Brume.SetActive(!Brume.activeInHierarchy);
    }
}
