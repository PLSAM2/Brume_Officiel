using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HurtBoxProj : MonoBehaviour
{
    public Projectile myProj;
    void OnTriggerEnter(Collider _coll)
	{
		myProj.TriggerEnter(_coll);
	}

	void Update()
	{
		transform.localPosition = Vector3.zero;
	}
}
