using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;


public class Projectile : MonoBehaviour
{

	[ReadOnly] public St_ProjectileInfos myInfos;
	Team team;

	public void SetupProjectile( St_ProjectileInfos _infos , Team _teamIndex )
	{
		myInfos.myDamages = _infos.myDamages;
		team = _teamIndex;
	}

	private void OnCollisionEnter ( Collision collision )
	{
		LocalPlayer playerHit = collision.gameObject.GetComponent<LocalPlayer>();

		if(playerHit != null)
		{
			if (playerHit.myPlayerModule.teamIndex != team)
			{
				playerHit.DealDamages(myInfos.myDamages);
				Destroy();
			}
			else
				return;
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

[System.Serializable]
public struct St_ProjectileInfos
{
	public DamagesInfos myDamages;
	public Vector3 myDirection;
	[HideInInspector] public float mySpeed, myLifeTime;
}
