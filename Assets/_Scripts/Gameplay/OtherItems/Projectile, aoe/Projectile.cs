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

	[Header("SpellLinked")]
	[TabGroup("ProjectileParameters")] [SerializeField] Sc_ProjectileSpell localTrad;
	float speed => localTrad.range / localTrad.salveInfos.timeToReachMaxRange;

	[TabGroup("ProjectileParameters")] [SerializeField] bool doImpactFx = true;
	Vector3 startPos;

	[HideInInspector] public bool hasTouched = false;
	[ShowIf("useRb")] public Rigidbody myRb;
	[SerializeField] AudioClip hitSound;
	[SerializeField] ushort bouncingNumber;
	ushort bouncingNumberLive;
	public Action velocityChanged;
	[SerializeField] LayerMask collisionMask;
	float projRadius;

	public override void Init ( Team ownerTeam )
	{
		base.Init(ownerTeam);
		startPos = transform.position;
		bouncingNumberLive = bouncingNumber;

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

		myRb.velocity = speed * transform.forward;
	}

	protected override void OnEnable ()
	{
		mylifeTime = localTrad.salveInfos.timeToReachMaxRange;
		base.OnEnable();
	}

	private void Start ()
	{
		myRb = GetComponent<Rigidbody>();
		projRadius = GetComponent<SphereCollider>().radius;
	}

	private void OnTriggerEnter ( Collider other )
	{
		Damageable playerHit = other.gameObject.GetComponent<Damageable>();
		PlayerModule playerTeam = other.gameObject.GetComponent<PlayerModule>();

		if (playerHit != null)
		{
			if (playerTeam.teamIndex != myteam)
			{
				hasTouched = true;

				if (!asDeal)
				{
					DamagesInfos _temp = new DamagesInfos();
					_temp = localTrad.damagesToDeal;
					playerHit.DealDamages(_temp, GameManager.Instance.currentLocalPlayer.transform.position);
				}
				Destroy();
				asDeal = true;

				if (isOwner && localTrad._reduceCooldowns)
					GameManager.Instance.currentLocalPlayer.myPlayerModule.reduceAllCooldown(localTrad.cooldownReduction);

				return;
			}
			else return;
		}
		else
		{
			/*
			
		}
	}
	/*	protected override void FixedUpdate ()
		{
			transform.position += speed * transform.forward * Time.fixedDeltaTime;
			base.FixedUpdate();
		}*/

		}
	}
	protected override void Destroy ()
	{
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

		asDeal = true;
		bouncingNumberLive = bouncingNumber;

		base.Destroy();
	}

	private void Update ()
	{
		RaycastHit _hit;
		if (Physics.SphereCast(transform.position, projRadius, myRb.velocity, out _hit,  .2f, LayerMask.GetMask("Environment")))
			Collide(_hit);
	}

	public void Collide ( RaycastHit _hit )
	{
		if (bouncingNumberLive == 0)
		{
			hasTouched = true;
			Destroy();
		}
		else
		{
			bouncingNumberLive--;
			myLivelifeTime = mylifeTime;
			//	transform.eulerAngles = new Vector3(0, Mathf.Atan2(_newDirection.x, _newDirection.z) * Mathf.Rad2Deg,0);
			myRb.velocity = speed * Vector3.Reflect(myRb.velocity, _hit.normal).normalized;
		}
	}
}

[System.Serializable]
public class ProjectileInfos
{
	public DamagesInfos myDamages;
	[HideInInspector] public float mySpeed;
}

