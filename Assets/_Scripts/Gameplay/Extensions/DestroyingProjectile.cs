using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyingProjectile : MonoBehaviour
{
    public PlayerModule myPlayerModule;
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
			if(!_coll.GetComponent<Damageable>().IsInMyTeam(myPlayerModule.teamIndex))
			{
				_coll.GetComponent<Projectile>().Destroy(false);
			}
		}
	}
}
