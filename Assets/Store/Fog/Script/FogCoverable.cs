using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogCoverable : MonoBehaviour
{
    Renderer myRenderer;

    void FieldOfViewOnTargetsVisibilityChange(List<Transform> newTargets)
    {
        myRenderer.enabled = newTargets.Contains(transform);
    }
}