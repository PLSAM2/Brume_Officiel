using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
using System;
using DG.Tweening;

public class Projectile : AutoKill
{
	bool asDeal = false;

	[Header("FeedBackOnHit")]
	[TabGroup("ProjectileParameters")] [SerializeField] GameObject feedBackTouch;
	[TabGroup("ProjectileParameters")] [SerializeField] AudioClip _mySfxAudio;
	[TabGroup("ProjectileParameters")] [SerializeField] bool soundFollowObj = false;
	[TabGroup("ProjectileParameters")] [SerializeField] GameObject aoeToSpawn;

	[Header("SpellLinked")]
	[TabGroup("ProjectileParameters")] [SerializeField] Sc_ProjectileSpell localTrad;
	public float speed => localTrad.range / localTrad.salveInfos.timeToReachMaxRange;

	[TabGroup("ProjectileParameters")] [SerializeField] bool doImpactFx = true;
	Vector3 startPos;

	[HideInInspector] public bool hasTouched = false;
	public Rigidbody myRb;
	[SerializeField] AudioClip hitSound;

	DamagesInfos _tempDamage = new DamagesInfos();

	Vector3 direction = Vector3.zero;
	ushort bouncingNumberLive;

	bool isBox = false;
	[HideInInspector] public Vector3 collisionSize;


	public override void Init ( Team ownerTeam, float _lifePercentage )
	{
		ResetDamages();

		base.Init(ownerTeam, _lifePercentage);

		if (GameManager.Instance.gameStarted)
		{
            if (NetworkManager.Instance.GetLocalPlayer().playerTeam != Team.spectator)
            {
				if ((GameManager.Instance.currentLocalPlayer.myPlayerModule.state & En_CharacterState.PoweredUp) != 0 && isOwner && localTrad.damagesToDeal.damageHealth > 0)
				{
					_tempDamage.damageHealth += 1;
					GameManager.Instance.currentLocalPlayer.myPlayerModule.RemoveState(En_CharacterState.PoweredUp);
				}
			}

		}

		startPos = transform.position;
		bouncingNumberLive = localTrad.bouncingNumber;
		

		if (!isOwner)
		{
			asDeal = true;
		}
		else
			asDeal = false;

		hasTouched = false;
		if (_mySfxAudio != null)
		{
			if (soundFollowObj)
			{
				AudioManager.Instance.Play3DAudio(_mySfxAudio, transform, myNetworkObject.GetItemID(), false);
			}
			else
			{
				AudioManager.Instance.Play3DAudio(_mySfxAudio, transform.position, myNetworkObject.GetItemID(), false);
			}
		}
	}

	void ResetDamages()
	{
		_tempDamage.damageHealth = localTrad.damagesToDeal.damageHealth;
		_tempDamage.statusToApply = localTrad.damagesToDeal.statusToApply;
		_tempDamage.movementToApply = localTrad.damagesToDeal.movementToApply;
	}

	protected void OnEnable ()
	{
		ResetDamages();
		mylifeTime = localTrad.salveInfos.timeToReachMaxRange;
		direction = transform.forward;
		myRb.velocity = speed * direction;
		transform.localScale = Vector3.one;
	}

	private void Start ()
	{
		myRb = GetComponent<Rigidbody>();

		BoxCollider _collBox = GetComponent<BoxCollider>();
		if (_collBox != null)
		{
			isBox = true;
			collisionSize = _collBox.size;
		}
		else
		{
			isBox = false;
			SphereCollider _coll = GetComponent<SphereCollider>();
			if (_coll != null)
				collisionSize = new Vector3(_coll.radius, 0, 0);
		}
	}

	void OnCollisionEnter ( Collision _coll )
	{
		Damageable _temp = _coll.gameObject.GetComponent<Damageable>();

		if (_temp == null)
		{
			if (bouncingNumberLive == 0)
			{
				hasTouched = true;
				Destroy(true);
				print("_coll "+ _coll.gameObject.name);
			}
			else
			{
				LocalPoolManager.Instance.SpawnNewImpactFX(transform.position, Quaternion.LookRotation(startPos - transform.position, transform.right), myteam);
				GameFactory.DoScreenShake(0.15f, 0.15f, transform.position);

				bouncingNumberLive--;
				myLivelifeTime = mylifeTime * localTrad.velocityKeptOnBounce;
				transform.LookAt(transform.position + Vector3.Reflect(transform.forward, _coll.GetContact(0).normal.normalized));

				if (isBox)
				{
					RaycastHit[] _collTouched = Physics.BoxCastAll(transform.position, collisionSize / 2, Vector3.zero, Quaternion.identity, 0, 1 << 8);

					foreach (RaycastHit _hit in _collTouched)
					{
						_hit.collider.GetComponent<LocalPlayer>().DealDamages(_tempDamage, transform);
					}
				}
				else
				{
					RaycastHit[] _collTouched = Physics.SphereCastAll(transform.position, transform.position.x, Vector3.zero, 1 << 8);

					foreach (RaycastHit _hit in _collTouched)
					{
						_hit.collider.GetComponent<LocalPlayer>().DealDamages(_tempDamage, transform);
					}
				}

			}
		}
	}




	protected override void Update ()
	{
		base.Update();	

		myRb.velocity = transform.forward * speed * localTrad._curveSpeed.Evaluate((mylifeTime - myLivelifeTime) / mylifeTime);

		if (localTrad.isScalable)
			transform.localScale = new Vector3(1 + localTrad.scaleCurve.Evaluate((mylifeTime - myLivelifeTime) / mylifeTime) * (localTrad.finalSize.x - 1),
											   1 + localTrad.scaleCurve.Evaluate((mylifeTime - myLivelifeTime) / mylifeTime) * (localTrad.finalSize.y - 1),
											   1 + localTrad.scaleCurve.Evaluate((mylifeTime - myLivelifeTime) / mylifeTime) * (localTrad.finalSize.z - 1));
	}

	void OnTriggerEnter ( Collider _coll )
	{
		Damageable _damageableHit = _coll.gameObject.GetComponent<Damageable>();
		if (_damageableHit != null)
		{
			if (!_damageableHit.IsInMyTeam(myteam))
			{
				hasTouched = true;


				if (isOwner && localTrad._reduceCooldowns)
					GameManager.Instance.currentLocalPlayer.myPlayerModule.reduceAllCooldown(localTrad.cooldownReduction);

				if (!asDeal)
				{
					_damageableHit.DealDamages(_tempDamage, GameManager.Instance.currentLocalPlayer.transform);


					if (localTrad.statusToApplyOnHit != null)
						GameManager.Instance.currentLocalPlayer.myPlayerModule.AddStatus(localTrad.statusToApplyOnHit.effect);

					if (localTrad.diesOnPlayerTouch)
					{
						Destroy(true);
					}
				}
				return;
			}
		}
		/*else if (localTrad.destroyProjectiles)
		{
			Projectile _proj = _coll.GetComponent<Projectile>();
			if (_proj != null)
			{
				_proj.Destroy(true);
			}
		}*/
		else if (localTrad.diesOnWallTrigger && _coll.tag != "DestroyProj")
		{
			Destroy(true);
		}
	}


	public override void Destroy ( bool _spawnAoe )
	{
		asDeal = true;

		if (hasTouched && doImpactFx)
		{
			LocalPoolManager.Instance.SpawnNewImpactFX(transform.position, Quaternion.LookRotation(startPos - transform.position, transform.right), myteam);

			GameFactory.DoScreenShake(0.15f, 0.15f, transform.position);

			if (hitSound)
			{
				AudioManager.Instance.Play3DAudio(hitSound, transform.position, myNetworkObject.GetItemID(), false);
			}
		}

		if (isOwner && aoeToSpawn != null)
		{
			if (_spawnAoe || localTrad.forcePrefabApparition)
			{
				NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeToSpawn), transform.position, transform.eulerAngles);
			}
		}


		bouncingNumberLive = localTrad.bouncingNumber;
		base.Destroy();
	}
}

[System.Serializable]
public class ProjectileInfos
{
	public DamagesInfos myDamages;
	[HideInInspector] public float mySpeed;
}

