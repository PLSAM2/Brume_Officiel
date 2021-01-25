using System.Collections;
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
		print(myRb.velocity);
	}

	

	public override void Destroy ()
	{

		if (!asExploded && hasTouched)
		{
			asExploded = true;

            AudioManager.Instance.Play3DAudio(explosionSound, transform.position, myNetworkObject.GetItemID(), false);

            //if (isOwner)
			//	Explode();
		}
		base.Destroy();
	}


	private void OnDisable ()
	{
		if(hasTouched)
		{
			CirclePreview _mypreview = PreviewManager.Instance.GetCirclePreview(null);
			_mypreview.Init(explosionRange, CirclePreview.circleCenter.center, transform.position);

			if (myteam == GameData.Team.blue)
				_mypreview.SetColor(Color.blue, .2f);
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
