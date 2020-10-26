using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;


public class Projectile : MonoBehaviour
{

	[ReadOnly] public St_ProjectileInfos myInfos;
	[SerializeField] Team team;
	CapsuleCollider myColl;
	[SerializeField] LayerMask layerToHit;


	private void Start ()
	{
		myColl = GetComponent<CapsuleCollider>();
	}

	/*private void OnCollisionEnter ( Collision collision )
	{
		LocalPlayer playerHit = collision.gameObject.GetComponent<LocalPlayer>();

		if(playerHit != null)
		{
			if (playerHit.myPlayerModule.teamIndex != team)
			{

			}
			else
				return;
		}
		Destroy();
	}*/

	private void Update ()
	{
		transform.position += myInfos.mySpeed * transform.forward * Time.deltaTime;
		CustomCollision();
	}

	void CustomCollision ()
	{
		RaycastHit[] _hits = Physics.CapsuleCastAll(transform.position + transform.forward / myColl.height / 2, transform.position - transform.forward / myColl.height / 2, myColl.radius, transform.forward, Time.deltaTime, layerToHit);

		Debug.DrawRay(transform.position, transform.position - transform.forward / myColl.height / 2 - transform.position + transform.forward / myColl.height / 2, Color.red, 10);

		bool _mustDestroy = false;

		if (_hits.Length > 0)
		{
			for(int i = 0; i < _hits.Length; i++)
			{

				PlayerModule playerHit = _hits[i].collider.GetComponent<PlayerModule>();

				if (playerHit != null)
				{
					if (playerHit.teamIndex != team)
					{
						playerHit.mylocalPlayer.DealDamages(myInfos.myDamages);
						_mustDestroy = true;
					}
					else
						return;
				}
				else
				{
					print(_hits[i].collider.name);
					_mustDestroy = true;
				}


			}
		}

		if (_mustDestroy)
			Destroy();
	}

	private void FixedUpdate ()
	{
		myInfos.myLifeTime -= Time.fixedDeltaTime;
		if (myInfos.myLifeTime <= 0)
		{
			Destroy();
		}
	}

	void Destroy ()
	{
		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
	}
}

[System.Serializable]
public struct St_ProjectileInfos
{
	public DamagesInfos myDamages;
	[ReadOnly] public float mySpeed, myLifeTime;
}
