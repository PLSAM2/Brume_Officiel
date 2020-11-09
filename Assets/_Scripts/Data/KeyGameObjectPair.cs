using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class KeyGameObjectPair
{
    public ushort Key = 0;
    public int poolCount = 1;
    public GameObject gameObject;
}
