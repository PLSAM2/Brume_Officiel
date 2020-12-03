
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class ModuleProjectileSpell : SpellModule
{
	protected Sc_ProjectileSpell localTrad; //plus facile a lire dans le script
	int shotRemainingInSalve;

	SalveInfos myLiveSalve;
	float offsetHeight;
	bool shooting = false;
	float timeBetweenShot = 0;
	ArrowPreview myPreviewArrow;
	ShapePreview myPreviewBurst;

	private void Start ()
	{
		localTrad = spell as Sc_ProjectileSpell;
		myLiveSalve = localTrad.salveInfos;
		offsetHeight = GetComponent<CapsuleCollider>().height / 2;
	}
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
			if (localTrad.salveInfos.numberOfShotInSalve > 1)
				myPreviewBurst = PreviewManager.Instance.GetShapePreview();
			else
				myPreviewArrow = PreviewManager.Instance.GetArrowPreview();
			HidePreview(Vector3.zero);
		}
	}

	protected override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		base.StartCanalysing(_BaseMousePos);

		HidePreview(Vector3.zero);
	}

	protected override void ResolveSpell ( )
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
		return transform.forward + transform.position + new Vector3(0, myPlayerModule.movementPart.collider.height / 2, 0);
	}

	protected virtual Vector3 RotationOfTheProj ()
	{
		return transform.rotation.eulerAngles;
	}

	void ShootSalve  ()
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
		/*
		float _baseAngle = transform.forward.y - spellProj.angleToSplit / 2;
		float _angleToAdd = spellProj.angleToSplit / spellProj.salveInfos.numberOfShot;

		for (int i = 0; i < spellProj.salveInfos.numberOfShot; i++)
		{
			Vector3 _PosToSpawn = Quaternion.Euler(0, _baseAngle, 0) * (transform.forward /10 );

			ShootProjectile(transform.position + _PosToSpawn, transform.rotation.eulerAngles + new Vector3(0, _baseAngle, 0));
			_baseAngle += _angleToAdd;
		}*/
		float _baseAngle = transform.forward.y - localTrad.angleToSplit / 2;
		float _angleToAdd = localTrad.angleToSplit / localTrad.salveInfos.numberOfShotInSalve;

		for (int i = 0; i < localTrad.salveInfos.numberOfShotInSalve; i++)
		{
			Vector3 _PosToSpawn = transform.forward * localTrad.offSet + new Vector3(0, offsetHeight, 0); //Quaternion.Euler(0, _baseAngle, 0) * (transform.forward * spellProj.offSet);

			ShootProjectile(transform.position + _PosToSpawn, transform.rotation.eulerAngles + new Vector3(0, _baseAngle, 0));
			_baseAngle += _angleToAdd;

		}
	}

	protected void ShootProjectile ( Vector3 _posToSet, Vector3 _rot )
	{
		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.prefab.gameObject), _posToSet, _rot);
	}
	#endregion

	//PREVIEW
	#region
	protected override void HidePreview (Vector3 _temp)
	{
		if (myPreviewArrow != null)
			myPreviewArrow.gameObject.SetActive(false);
		else
			myPreviewBurst.gameObject.SetActive(false);

		base.HidePreview(_temp);
	}

	protected override void UpdatePreview ()
	{
		if (myPreviewArrow != null)
		{

				myPreviewArrow.Init(transform.position, transform.position + (Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * localTrad.range), .1f);
		}else
		{
			myPreviewBurst.Init(localTrad.range, localTrad.angleToSplit, 0, Vector3.zero);
		}

		base.UpdatePreview();
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		if(canBeCast())
		{
			if (myPreviewArrow != null)
				myPreviewArrow.gameObject.SetActive(true);
			else
				myPreviewBurst.gameObject.SetActive(true);
		}

		base.ShowPreview(mousePos);
	}


	#endregion
}
