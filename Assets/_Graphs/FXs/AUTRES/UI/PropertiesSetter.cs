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

    Image myImage;

    private void Start()
    {
        myImage = GetComponent<Image>();

        myImage.material = Instantiate<Material>(myMat);
        currentMat = myImage.material;
    }

    void Update()
    {
        if (refresh)
        {
            refresh = false;

            myImage.material = Instantiate<Material>(myMat);
            currentMat = myImage.material;
        }

        value = Mathf.Clamp(value, 0, 1);
        currentMat.SetFloat(properties, value);
    }
}
