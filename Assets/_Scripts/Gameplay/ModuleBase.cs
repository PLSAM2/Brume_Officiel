using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModuleBase : MonoBehaviour
{
    public ushort myId;

    public virtual void Start()
	{
		myId = GetComponent<PlayerModule>().myId;
	}
}
