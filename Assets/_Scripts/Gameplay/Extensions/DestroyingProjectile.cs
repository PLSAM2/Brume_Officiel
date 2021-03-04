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
		/*Collider[] _temp = Physics.OverlapSphere(transform.position, radius, 20);
		foreach(Collider _coll in _temp)
		{
			if (! myPlayerModule.mylocalPlayer.IsInMyTeam(_coll.GetComponent<Projectile>().myteam) && myPlayerModule.mylocalPlayer.isOwner)
			{
				_coll.GetComponent<Projectile>().Destroy(false);
			}
		}*/
	}

	private void OnTriggerEnter ( Collider other )
	{
		if (!myPlayerModule.mylocalPlayer.IsInMyTeam(other.GetComponent<Projectile>().myteam) && myPlayerModule.mylocalPlayer.isOwner)
		{
			other.GetComponent<Projectile>().Destroy(false);
		}
	}
}
