using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

[InlineEditor]
public class Projectile : MonoBehaviour
{

	[ReadOnly] public St_ProjectileInfos myInfos;
	[SerializeField] Team team;
	SphereCollider myColl;
	[SerializeField] LayerMask layerToHit;
	[SerializeField] GameObject feedBackTouch;
	[SerializeField] Sc_ProjectileSpell spellRule;

	private void Start ()
	{
		myColl = GetComponent<SphereCollider>();
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
		RaycastHit[] _hits = Physics.SphereCastAll(transform.position, myColl.radius, transform.forward, .1f, layerToHit);


		bool _mustDestroy = false;
		Vector3 _PosToSpawn = Vector3.zero;
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
						_PosToSpawn = _hits[i].point;
							
						return;
					}
					else
						return;
				}
				else
				{
					// print(_hits[i].collider.name);
					_PosToSpawn = _hits[i].point;
					_mustDestroy = true;
				}


			}
		}

		if (_mustDestroy)

		{
			if(_PosToSpawn != Vector3.zero)
				Instantiate(feedBackTouch, _PosToSpawn, Quaternion.identity);

			Destroy();
		}
	}

	private void FixedUpdate ()
	{
		myInfos.myLifeTime -= Time.fixedDeltaTime;
		if (myInfos.myLifeTime <= 0)
		{
            // print("OUtOFTIme");


			Destroy();
		}
	}

	void Destroy ()
	{
		if (this.GetComponent<NetworkedObject>().GetIsOwner())
		{
			NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
		}
	}

	[Button]
	void SetupPrefab ()
	{
		myInfos.myDamages.damageHealth = spellRule.projParameters.myDamages.damageHealth;
		myInfos.mySpeed = spellRule.range / spellRule.salveInfos.timeToReachMaxRange;
		myInfos.myLifeTime = spellRule.salveInfos.timeToReachMaxRange;
	}
}

[System.Serializable]
public struct St_ProjectileInfos
{
	public DamagesInfos myDamages;
	[ReadOnly] public float mySpeed, myLifeTime;
}
