using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GainUltiElement : MonoBehaviour
{
    [SerializeField] GameObject prefabUltiElement;

    [SerializeField] float startSize = 40;

    public void Init(int numberUlti)
    {
        for (int i = 0; i < numberUlti; i++)
        {
            UltiElement newElement = Instantiate(prefabUltiElement, transform).GetComponent<UltiElement>();
            newElement.InstantSetValue(1);

            RectTransform rectElement = newElement.GetComponent<RectTransform>();
            SetSize(startSize, rectElement);
        }

        Destroy(gameObject, 3);
    }

    void SetSize(float size, RectTransform rt)
    {
        rt.sizeDelta = new Vector2(size, size);
    }
}
