using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NetworkedObjectsList", menuName = "Custom/New Networked objects list")]
[InlineEditor]
public class Sc_NetworkedObjects : SerializedScriptableObject
{
    public List<Sc_Status> allStatusOfTheGame;

    [BoxGroup("KEY MUST BE UNIQUE")]
    public List<KeyGameObjectPair> networkObjects = new List<KeyGameObjectPair>();

}

