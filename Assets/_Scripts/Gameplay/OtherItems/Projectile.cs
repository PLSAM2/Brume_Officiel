using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Projectile : MonoBehaviour
{

	[ReadOnly] public St_ProjectileInfos myInfos;
	[SerializeField] Team team;
	SphereCollider myColl;
	[SerializeField] LayerMask layerToHit;
	[SerializeField] GameObject feedBackTouch;
	[SerializeField] Sc_ProjectileSpell spellRule;
	bool isOwner, asDeal = false;
	[SerializeField] GameObject mesh;
	[SerializeField] AudioClip _mySfxAudio;
	[SerializeField] bool _reduceCooldowns = true;

	private void Start ()
	{
		myColl = GetComponent<SphereCollider>();
		isOwner = GetComponent<NetworkedObject>().GetIsOwner();
		asDeal = false;
	}

	private void OnEnable ()
	{
		myInfos.myLifeTime = spellRule.salveInfos.timeToReachMaxRange;
		mesh.SetActive(true);

		if (!isOwner)
		{
			asDeal = true;
		}
		else
			asDeal = false;
	}

	public void Init(Team ownerTeam)
	{
		team = ownerTeam;
		if (_mySfxAudio != null)
		{
			AudioManager.Instance.Play3DAudio(_mySfxAudio, transform);
		}
	}

	private void OnTriggerEnter ( Collider Collider )
	{
		PlayerModule playerHit = Collider.gameObject.GetComponent<PlayerModule>();
		/*
		if(playerHit != null)
		{
			if (playerHit.myPlayerModule.teamIndex != team)
			{

			}
			else
				return;
		}
		Destroy();*/

		if (playerHit != null)
		{

			if (playerHit.teamIndex != team)
			{
				if (!asDeal)
				{
					playerHit.mylocalPlayer.DealDamages(myInfos.myDamages);
				}

				Destroy();
				asDeal = true;

				if (isOwner && _reduceCooldowns)
					PlayerModule.reduceAllCooldown(spellRule.cooldownReduction);

				return;
			}
			else return;
		}
		else
		{
			Destroy();
		}

	}

	private void Update ()
	{
		transform.position += myInfos.mySpeed * transform.forward * Time.deltaTime;
		//CustomCollision();

		myInfos.myLifeTime -= Time.deltaTime;
		if (myInfos.myLifeTime <= 0)
		{
			Destroy();
		}
	}
	/*
	void CustomCollision ()
	{
		RaycastHit[] _hits = Physics.SphereCastAll(transform.position, myColl.radius, transform.forward, .1f, layerToHit);


		bool _mustDestroy = false;
		Vector3 _PosToSpawn = Vector3.zero;

		if (_hits.Length > 0 && !asDeal)
		{
			for (int i = 0; i < _hits.Length; i++)
			{

				PlayerModule playerHit = _hits[i].collider.GetComponent<PlayerModule>();

				if (playerHit != null)
				{
					if (playerHit.teamIndex != team)
					{
						playerHit.mylocalPlayer.DealDamages(myInfos.myDamages);
						Instantiate(feedBackTouch, _hits[i].point, Quaternion.identity);
						Destroy();
						_mustDestroy = true;
						_PosToSpawn = _hits[i].point;
						asDeal = true;
						if (isOwner)
							PlayerModule.reduceAllCooldown(spellRule.cooldownReduction);
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
					Instantiate(feedBackTouch, _hits[i].point, Quaternion.identity);
					Destroy();

				}


			}
		}


	}*/

	void Destroy ()
	{
		mesh.SetActive(false);
		asDeal = true;

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
