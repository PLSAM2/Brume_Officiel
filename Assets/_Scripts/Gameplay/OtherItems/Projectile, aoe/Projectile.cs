using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
using System;
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
	[HideInInspector] public Rigidbody myRb;
	[SerializeField] AudioClip hitSound;
	[TabGroup("Proj Specific touch interaction")] [HorizontalGroup(150)] public bool diesOnPlayerTouch = true;
	[TabGroup("Proj Specific touch interaction")] [HorizontalGroup(150)] public bool diesOnWallTouch = false;

	Vector3 direction = Vector3.zero;
	ushort bouncingNumberLive;


	public Action velocityChanged;

	public override void Init ( Team ownerTeam )
	{
		base.Init(ownerTeam);
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

	protected override void OnEnable ()
	{
		mylifeTime = localTrad.salveInfos.timeToReachMaxRange;
		direction = transform.forward;
		myRb.velocity = speed * direction;

		base.OnEnable();
	}

	private void Start ()
	{
		myRb = GetComponent<Rigidbody>();
	}

	void OnCollisionEnter ( Collision _coll )
	{
		Damageable _temp = _coll.gameObject.GetComponent<Damageable>();

		if (_temp == null)
		{
			if (bouncingNumberLive == 0)
			{
				hasTouched = true;
				Destroy();
			}
			else
			{
				bouncingNumberLive--;
				myLivelifeTime = mylifeTime *	localTrad.velocityKeptOnBounce;
				direction = Vector3.Reflect(direction, _coll.GetContact(0).normal).normalized;
				myRb.velocity = speed * direction;


			}
		}
	}

	private void Update ()
	{
		myRb.velocity = direction * speed * localTrad._curveSpeed.Evaluate((mylifeTime -myLivelifeTime) / mylifeTime);
	}

	void OnTriggerEnter ( Collider _coll )
	{
		Damageable _damageableHit = _coll.gameObject.GetComponent<Damageable>();

		if (_damageableHit != null)
		{
			if (!_damageableHit.IsInMyTeam(myteam))
			{
				hasTouched = true;

				if (!asDeal)
				{
					DamagesInfos _temp = new DamagesInfos();
					_temp = localTrad.damagesToDeal;
					_damageableHit.DealDamages(_temp, GameManager.Instance.currentLocalPlayer.transform.position);
				}


				if (diesOnPlayerTouch)
				{
					Destroy();
				}


				if (isOwner && localTrad._reduceCooldowns)
					GameManager.Instance.currentLocalPlayer.myPlayerModule.reduceAllCooldown(localTrad.cooldownReduction);

				return;
			}
		}
		else
		{
			Projectile _proj = _coll.GetComponent<Projectile>();
			if (_proj != null)
			{
				_proj.Destroy();
			}
			else if (diesOnWallTouch)
				Destroy();
		}
	}


	public override void Destroy ()
	{
		asDeal = true;
		if (hasTouched && doImpactFx)
		{
			LocalPoolManager.Instance.SpawnNewImpactFX(transform.position, Quaternion.LookRotation(startPos - transform.position, transform.right), myteam);

			Transform player = GameFactory.GetActualPlayerFollow().transform;

			if (player != null && Vector3.Distance(player.position, transform.position) < 7)
			{
				CameraManager.Instance.SetNewCameraShake(0.05f, 0.05f);
			}

			if (hitSound)
			{
				AudioManager.Instance.Play3DAudio(hitSound, transform.position, myNetworkObject.GetItemID(), false);
			}
		}

		if (aoeToSpawn != null && isOwner)
			NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeToSpawn), transform.position, transform.eulerAngles);

		bouncingNumberLive =localTrad.bouncingNumber;
		base.Destroy();
	}
}

[System.Serializable]
public class ProjectileInfos
{
	public DamagesInfos myDamages;
	[HideInInspector] public float mySpeed;
}

