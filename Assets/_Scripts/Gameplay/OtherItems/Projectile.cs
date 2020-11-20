﻿using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Projectile : AutoKill
{

	bool  asDeal = false;
	
	[Header("FeedBackOnHit")]
	[SerializeField] GameObject feedBackTouch;
	[SerializeField] AudioClip _mySfxAudio;

	[Header("SpellLinked")]
	[SerializeField] Sc_ProjectileSpell localTrad;
	float speed => localTrad.range / localTrad.salveInfos.timeToReachMaxRange ;

	public override void Init(Team ownerTeam)
	{
		base.Init(ownerTeam);

		asDeal = true;

		if (!isOwner)
		{
			asDeal = true;
		}
		else
			asDeal = false;


		if (_mySfxAudio != null)
		{
			AudioManager.Instance.Play3DAudio(_mySfxAudio, transform);
		}

	

	}

	protected override void OnEnable ()
	{
		mylifeTimeInfos.myLifeTime = localTrad.salveInfos.timeToReachMaxRange;
		print(mylifeTimeInfos.myLifeTime);
		base.OnEnable(); 
	}

	private void OnTriggerEnter ( Collider Collider )
	{
		PlayerModule playerHit = Collider.gameObject.GetComponent<PlayerModule>();

		if (playerHit != null)
		{

			if (playerHit.teamIndex != myteam)
			{
				if (!asDeal)
				{
					playerHit.mylocalPlayer.DealDamages(localTrad.damagesToDeal, GetComponent<NetworkedObject>().GetOwner());
					if(localTrad.onHitForcedMovementToApply != null)
					{
						playerHit.mylocalPlayer.SendForcedMovement(localTrad.onHitForcedMovementToApply.MovementToApply(playerHit.transform.position, GameManager.Instance.currentLocalPlayer.transform.position));
					}
				}

				Destroy();
				asDeal = true;

				if (isOwner && localTrad._reduceCooldowns)
					PlayerModule.reduceAllCooldown(localTrad.cooldownReduction);

				return;
			}
			else return;
		}
		else
		{
			Destroy();
		}

	}

	protected override void FixedUpdate ()
	{
		transform.position += speed * transform.forward * Time.fixedDeltaTime;
		base.FixedUpdate();
	}

	protected override void Destroy ()
	{
		asDeal = true;

		base.Destroy();
	}
}

[System.Serializable]
public class ProjectileInfos 
{
	public DamagesInfos myDamages;
	[HideInInspector] public float mySpeed;
}

[System.Serializable]
public class KillLifeTime
{
	public float myLifeTime;
}
