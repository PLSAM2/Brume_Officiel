using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Projectile : AutoKill
{

	[ReadOnly] public ProjectileInfos myInfos;
	[SerializeField] Team team;
	[SerializeField] LayerMask layerToHit;
	[SerializeField] GameObject feedBackTouch;
	[SerializeField] Sc_ProjectileSpell spellRule;
	bool isOwner, asDeal = false;
	[SerializeField] AudioClip _mySfxAudio;
	[SerializeField] bool _reduceCooldowns = true;

	public void Init(Team ownerTeam)
	{
		asDeal = true;

		isOwner = GetComponent<NetworkedObject>().GetIsOwner();

		if (!isOwner)
		{
			asDeal = true;
		}
		else
			asDeal = false;


		team = ownerTeam;
		if (_mySfxAudio != null)
		{
			AudioManager.Instance.Play3DAudio(_mySfxAudio, transform);
		}


	}
	protected override void OnEnable ()
	{
		myInfos.myDamages.damageHealth = spellRule.projParameters.myDamages.damageHealth;
		myInfos.mySpeed = spellRule.range / spellRule.salveInfos.timeToReachMaxRange;
		mylifeTimeInfos.myLifeTime = spellRule.salveInfos.timeToReachMaxRange;




		base.OnEnable();
	}

	private void OnTriggerEnter ( Collider Collider )
	{
		PlayerModule playerHit = Collider.gameObject.GetComponent<PlayerModule>();

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
	[ReadOnly] public float mySpeed;
}

[System.Serializable]
public class KillLifeTime
{
	[ReadOnly] public float myLifeTime;
}
