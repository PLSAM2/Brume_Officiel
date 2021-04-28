using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class quickFix : MonoBehaviour
{
	Vector3 basepos;

	private void Start ()
	{
		basepos = transform.localPosition;
	}

	public void ResetAnimatorPos()
	{
		transform.localPosition = basepos;
	}
}
