using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile : MonoBehaviour
{

	ProjectileInfos myInfos;
	

	public void SetupProjectile( ProjectileInfos _infos )
	{
		myInfos.myDamages = _infos.myDamages;
	}

	private void OnCollisionEnter ( Collision collision )
	{
		LocalPlayer playerHit = collision.gameObject.GetComponent<LocalPlayer>();

		if(playerHit != null)
		{
			playerHit.DealDamages(myInfos.myDamages);
		}

		Destroy();
	}

	private void Update ()
	{
		transform.position += myInfos.mySpeed * myInfos.myDirection * Time.deltaTime;
	}

	private void FixedUpdate ()
	{
		myInfos.myLifeTime -= Time.fixedDeltaTime;
		if(myInfos.myLifeTime <=0)
		{
			Destroy();
		}
	}

	void Destroy()
	{
		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
	}
}

public class ProjectileInfos
{
	public DamagesInfos myDamages;
	public Vector3 myDirection;
	[HideInInspector] public float mySpeed, myLifeTime;
}
