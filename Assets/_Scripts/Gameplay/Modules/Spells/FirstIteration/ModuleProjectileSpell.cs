
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

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

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
			for (int i = 0; i < localTrad.salveInfos.numberOfShotInSalve; i++)
			{
				ArrowPreview _temp = PreviewManager.Instance.GetArrowPreview();
				myPreviewArrow.Add(_temp);
			}

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

	protected override void UpgradeSpell ()
	{
		base.UpgradeSpell();
		myLiveSalve.timeToResolveTheSalve += localTrad.durationAdded;
		myLiveSalve.NumberOfSalve += localTrad.bonusSalve;
		myLiveSalve.numberOfShotInSalve += localTrad.bonusShot;
	}

	protected override void ReturnToNormal ()
	{
		base.ReturnToNormal();
		myLiveSalve = localTrad.salveInfos;
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
		float _angleToAdd = localTrad.angleToSplit / localTrad.salveInfos.numberOfShotInSalve;

		for (int i = 0; i < localTrad.salveInfos.numberOfShotInSalve; i++)
		{
			RaycastHit _hit;
			if (Physics.Raycast(transform.position, Quaternion.AngleAxis(_baseAngle, Vector3.up) * myPlayerModule.directionOfTheMouse(), out _hit, localTrad.prefab.myLivelifeTime * localTrad.prefab.speed, 1 << 9))
			{
				myPreviewArrow[i].Init(transform.position, _hit.point, .1f);
				print(_hit.point);
			}
			else
				myPreviewArrow[i].Init(transform.position, transform.position + (Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * (localTrad.range)), .1f);

			_baseAngle += _angleToAdd;
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
