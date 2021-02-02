using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyingProjectile : MonoBehaviour
{
    [SerializeField] PlayerModule myPlayerModule;
	float radius;


	private void Awake ()
	{
		radius = GetComponent<SphereCollider>().radius;
		gameObject.SetActive(false);
	}

	private void OnEnable()
	{
		Collider[] _temp = Physics.OverlapSphere(transform.position, radius, 20);

		foreach(Collider _coll in _temp)
		{
			_coll.GetComponent<Projectile>().Destroy(false);
		}
	}
}
