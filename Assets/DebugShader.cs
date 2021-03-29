using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
public class DebugShader : MonoBehaviour
{
    public string[] propertyName;
    public string lightColorPropertyName;
    public Material[] toSet;
    public Transform posPlayer;
    public Color lightColor;

    void Update()
    {
        UpdateMaterials();
        UpdateLightsColor();
    }

    [Button]
    void UpdateMaterials()
    {
        foreach (string _name in propertyName)
        {
            foreach (Material _mat in toSet)
            {
                _mat.SetVector(_name, posPlayer.position);
            }
        }
    }

    [Button]
    void UpdateLightsColor()
    {
        foreach (Material _mat in toSet)
        {
            _mat.SetColor(lightColorPropertyName, lightColor);
        }
    }
}
