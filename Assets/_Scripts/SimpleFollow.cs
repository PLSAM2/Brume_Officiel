using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
	Quaternion baseRot;
	private void Start ()
	{
		baseRot = transform.rotation;
	}

	void LateUpdate()
    {
		transform.rotation = baseRot;
    }
}
