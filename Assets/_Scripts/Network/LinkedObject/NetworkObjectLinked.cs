using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetworkObjectLinked : ScriptableObject
{
    public virtual void Linked(NetworkedObject networkedObject)  { }
}
