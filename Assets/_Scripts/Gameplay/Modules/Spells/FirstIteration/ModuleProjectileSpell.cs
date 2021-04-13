
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class ModuleProjectileSpell : SpellModule
{
	protected Sc_ProjectileSpell localTrad; //plus facile a lire dans le script
	int shotRemainingInSalve;

	SalveInfos myLiveSalve;
	bool shooting = false;
	float timeBetweenShot = 0;
	List<ArrowPreview> myPreviewArrow;

	protected  void FixedUpdate ()
	{
		if (shooting == true)
		{
			timeBetweenShot -= Time.fixedDeltaTime;
			if (timeBetweenShot <= 0)
			{
				ShootSalve();
			}
		}
	}

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{

		base.SetupComponent(_actionLinked);

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			localTrad = spell as Sc_ProjectileSpell;
			myLiveSalve = localTrad.salveInfos;

			myPreviewArrow = new List<ArrowPreview>();
			/*for (int i = 0; i < 2; i++)
			{*/
			ArrowPreview _temp = PreviewManager.Instance.GetArrowPreview();
			myPreviewArrow.Add(_temp);
			//}

			HidePreview(Vector3.zero);
		}
	}
	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		shotRemainingInSalve = myLiveSalve.NumberOfSalve;
		shooting = true;
		ShootSalve();
	}


	//shootingPart
	#region 
	protected virtual Vector3 PosToInstantiate ()
	{
		Vector3 _temp = transform.forward * .1f + transform.position;
		_temp.y = 0;
		return _temp;
	}

	protected virtual Vector3 RotationOfTheProj ()
	{
		return transform.rotation.eulerAngles;
	}

	void ShootSalve ()
	{
		timeBetweenShot = myLiveSalve.timeToResolveTheSalve / myLiveSalve.NumberOfSalve;

		shotRemainingInSalve--;

		if (shotRemainingInSalve <= 0)
		{
			shooting = false;
			Interrupt();
		}

		ReadSalve();
	}

	protected void ReadSalve ()
	{
		float _baseAngle = transform.forward.y - localTrad.angleToSplit / 2;
		float _angleToAdd = localTrad.angleToSplit / localTrad.salveInfos.numberOfShotInSalve;

		for (int i = 0; i < localTrad.salveInfos.numberOfShotInSalve; i++)
		{
			ShootProjectile(PosToInstantiate(), transform.rotation.eulerAngles + new Vector3(0, _baseAngle, 0));
			_baseAngle += _angleToAdd;
		}
	}

	protected void ShootProjectile ( Vector3 _posToSet, Vector3 _rot )
	{
		NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.prefab.gameObject), _posToSet, _rot, 1);
	}
	#endregion

	//PREVIEW
	#region
	protected override void HidePreview ( Vector3 _temp )
	{
		base.HidePreview(_temp);
		foreach (ArrowPreview _prev in myPreviewArrow)
			_prev.gameObject.SetActive(false);
	}

	protected override void UpdatePreview ()
	{
		float _baseAngle = transform.forward.y - localTrad.angleToSplit / 2;

		RaycastHit _hit;
		Vector3 _baseDirection = Quaternion.AngleAxis(_baseAngle, Vector3.up) * myPlayerModule.directionOfTheMouse();


		if (Physics.SphereCast(transform.position,
			localTrad.prefab.collisionSize.x,
			transform.forward,
			out _hit,
			localTrad.fakeRange,
			1 << 9))
		{
			myPreviewArrow[0].Init(transform.position, _hit.point,localTrad.fakeWidthStart, localTrad.fakeWidthEnd);
			myPreviewArrow[0].gameObject.SetActive(true);

			/*	if (localTrad.bouncingNumber > 0)
				{

					RaycastHit _newHit;
					if (Physics.Raycast(transform.position, Vector3.Reflect(_baseDirection, _hit.normal), out _newHit, localTrad.fakeRange, 1 << 9))
						myPreviewArrow[1].Init(_hit.point, _newHit.point, .1f);
					else
						myPreviewArrow[1].Init(_hit.point, _hit.point + Vector3.Reflect(_baseDirection, _hit.normal).normalized * localTrad.fakeRange, .1f);
				}*/
		}
		else
		{
			myPreviewArrow[0].Init(transform.position, transform.position + (Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * (localTrad.fakeRange)), localTrad.fakeWidthStart, localTrad.fakeWidthEnd);
			//myPreviewArrow[1].gameObject.SetActive(true);

		}


		base.UpdatePreview();
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (canBeCast())
			foreach (ArrowPreview _prev in myPreviewArrow)
				_prev.gameObject.SetActive(true);
	}

	protected override void CancelSpell ( bool _isForcedInterrupt )
	{
		base.CancelSpell(_isForcedInterrupt);
		if (shooting == true)
		{
			shooting = false;
			DecreaseCharge();
		}
	}

	#endregion
}
