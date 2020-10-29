using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class KeyInteractiblePair
{
    [ReadOnly] public ushort Key = 0;
    public Interactible interactible;
}
