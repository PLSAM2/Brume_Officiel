using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[ExecuteAlways]
public class LightManager : MonoBehaviour
{
    public List<GameObject> lightsArray = new List<GameObject>();
    public List<Vector4> lightsPos = new List<Vector4>();
    public Material[] toSet;
    public Color fakeLightColor = Color.white;
    public float fakeLightStep = 0;
    public float fakeLightStepAttenuation = 1;
    public float waveFakeLight_Max = 1.1f;
    public float waveFakeLight_Min = 1;
    public float waveFakeLight_Time = 1;
    public int fakeLightArrayLength = 1;

    void Update()
    {
        UpdateLightsPosArray();
        UpdateLightsProperties();
    }

    
    [Button]
    void UpdateLightsPosArray()
    {
        lightsPos.Clear();

        for (int i=0; i<lightsArray.Count; i++)
        {
            lightsPos.Add(lightsArray[i].transform.position);
        }

        Shader.SetGlobalVectorArray("FakeLightsPositionsArray", lightsPos);

        foreach (Material _mat in toSet)
        {
            _mat.SetFloat("_FakeLightArrayLength", fakeLightArrayLength);
        }
    }

    

    [Button]
    void UpdateLightsProperties()
    {
        foreach (Material _mat in toSet)
        {
            _mat.SetColor("_FakeLight_Color", fakeLightColor);
            _mat.SetFloat("_FakeLightStep", fakeLightStep);
            _mat.SetFloat("_FakeLightStepAttenuation", fakeLightStepAttenuation);
            _mat.SetFloat("_WaveFakeLight_Max", waveFakeLight_Max);
            _mat.SetFloat("_WaveFakeLight_Min", waveFakeLight_Min);
            _mat.SetFloat("_WaveFakeLight_Time", waveFakeLight_Time);
        }
    }
}