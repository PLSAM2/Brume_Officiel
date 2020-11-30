using Sirenix.OdinInspector;
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
	[SerializeField] bool soundFollowObj = false;

	[Header("SpellLinked")]
	[SerializeField] Sc_ProjectileSpell localTrad;
	float speed => localTrad.range / localTrad.salveInfos.timeToReachMaxRange;

    [SerializeField] bool doImpactFx = false;
    Vector3 startPos;

	public override void Init(Team ownerTeam)
	{
		base.Init(ownerTeam);
        startPos = transform.position;

		asDeal = true;

		if (!isOwner)
		{
			asDeal = true;
		}
		else
			asDeal = false;


		if (_mySfxAudio != null)
		{
            if (soundFollowObj)
            {
				AudioManager.Instance.Play3DAudio(_mySfxAudio, transform);
			}
            else
            {
				AudioManager.Instance.Play3DAudio(_mySfxAudio, transform.position);
			}
		}
	}

	protected override void OnEnable ()
	{
		mylifeTime = localTrad.salveInfos.timeToReachMaxRange;
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
					playerHit.mylocalPlayer.DealDamages(localTrad.damagesToDeal, GameManager.Instance.currentLocalPlayer.transform.position, GetComponent<NetworkedObject>().GetOwner());
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

        if (doImpactFx)
        {
            LocalPoolManager.Instance.SpawnNewImpactFX(transform.position, Quaternion.LookRotation(startPos - transform.position, transform.right), myteam);
        }

        base.Destroy();
	}
}

[System.Serializable]
public class ProjectileInfos 
{
	public DamagesInfos myDamages;
	[HideInInspector] public float mySpeed;
}

