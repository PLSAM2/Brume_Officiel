using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class PropertiesSetter : MonoBehaviour
{
    public string properties = "_test";
    public float value = 0;

    public Material myMat;
    Material currentMat;

    public bool refresh = false;

    private void Start()
    {
        GetComponent<Image>().material = Instantiate<Material>(myMat);
        currentMat = GetComponent<Image>().material;
    }

    void Update()
    {
        if (refresh)
        {
            refresh = false;

            GetComponent<Image>().material = Instantiate<Material>(myMat);
            currentMat = GetComponent<Image>().material;
        }

        value = Mathf.Clamp(value, 0, 1);
        currentMat.SetFloat(properties, value);
    }
}
