using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NetworkedObjectsList", menuName = "Custom/New Networked objects list")]
[InlineEditor]
public class Sc_NetworkedObjects : SerializedScriptableObject
{
    public Dictionary<ushort, GameObject> networkObjects = new Dictionary<ushort, GameObject>();
}

