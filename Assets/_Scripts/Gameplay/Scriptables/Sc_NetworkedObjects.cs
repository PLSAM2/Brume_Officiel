using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NetworkedObjectsList", menuName = "Custom/New Networked objects list")]
[InlineEditor]
public class Sc_NetworkedObjects : SerializedScriptableObject
{
    [BoxGroup]
    [Title("KEY MUST BE UNIQUE")]
    public List<KeyGameObjectPair> networkObjects = new List<KeyGameObjectPair>();
}

