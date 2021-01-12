﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class Projectile_SoulBurst : Projectile
{
	[TabGroup("Explosion")] public float explosionRange = 3;
	[TabGroup("Explosion")] public DamagesInfos damagesExplosion;
	bool asExploded = false;
	bool isInMyTeam;

    [SerializeField] AudioClip explosionSound;

	public override void Init ( GameData.Team ownerTeam )
	{
		base.Init(ownerTeam);
		asExploded = false;
	}

	private List<LocalPlayer> GetAllNearbyPlayers ()
	{
		List<LocalPlayer> _temp = new List<LocalPlayer>();

		foreach (LocalPlayer P in GameManager.Instance.networkPlayers.Values)
		{
			if (Vector3.Distance(P.transform.position, this.transform.position) < explosionRange)
			{
				if (P.myPlayerModule.teamIndex == myNetworkObject.GetOwner().playerTeam)
				{
					continue;
				}
				_temp.Add(P);
			}
		}
		return _temp;
	}

	public void Explode ()
	{
		foreach (LocalPlayer P in GetAllNearbyPlayers())
		{
			P.DealDamages(damagesExplosion, transform.position, GameManager.Instance.currentLocalPlayer.myPlayerId);
		}
	}

	protected override void Destroy ()
	{

		if (!asExploded && hasTouched)
		{
			asExploded = true;

			isInMyTeam = (myteam == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex);

            AudioManager.Instance.Play3DAudio(explosionSound, transform.position);

            if (isOwner)
				Explode();
		}
		base.Destroy();
	}


	private void OnDisable ()
	{
		if(hasTouched)
		{
			CirclePreview _mypreview = PreviewManager.Instance.GetCirclePreview(null);
			_mypreview.Init(explosionRange, CirclePreview.circleCenter.center, transform.position);

			if (isInMyTeam)
				_mypreview.SetColor(Color.yellow, .2f);
			else
				_mypreview.SetColor(Color.red, .2f);

			_mypreview.SetLifeTime(.3f);
		}
	}

	void OnDrawGizmosSelected ()
	{
		Gizmos.color = Color.yellow;
		Gizmos.DrawWireSphere(transform.position, explosionRange);
	}
}
