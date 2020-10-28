using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogCoverable : MonoBehaviour
{
    Renderer renderer;



    void FieldOfViewOnTargetsVisibilityChange(List<Transform> newTargets)
    {
        renderer.enabled = newTargets.Contains(transform);
    }
}