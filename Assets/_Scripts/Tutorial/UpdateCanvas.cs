using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UpdateCanvas : MonoBehaviour
{
    public RectTransform quest;

    void Update()
    {
        LayoutRebuilder.ForceRebuildLayoutImmediate(quest);
    }
}
