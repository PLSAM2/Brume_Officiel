using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[ExecuteAlways]
public class LightManager : MonoBehaviour
{
    public List<GameObject> lightsArray = new List<GameObject>();
    public List<Vector4> lightsPos = new List<Vector4>();
    public string lightColorPropertyName;
    public Material[] toSet;
    public Color lightColor;

    void Update()
    {
        UpdateLightsPosArray();
        UpdateLightsColor();
    }

    
    [Button]
    void UpdateLightsPosArray()
    {
        lightsPos.Clear();

        for (int i=0; i<lightsArray.Count; i++)
        {
            lightsPos.Add(lightsArray[i].transform.position);
        }

        Shader.SetGlobalVectorArray("LightsPositionsArray", lightsPos);

        foreach (Material _mat in toSet)
        {
            _mat.SetFloat("_LightArrayLength", lightsPos.Count);
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