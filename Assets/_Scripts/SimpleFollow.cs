﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
	public Vector3 baseRot;

	void Update()
    {
		transform.eulerAngles = baseRot;
    }
}
