using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FixedDistanceAoe : SpellModule
{
	public Aoe aoeInstantiated;
	SquarePreview mySquarePreview;
	CirclePreview myCirclePreview;
	public bool spawnOnPos = false;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		if (isOwner)
		{
			if (aoeInstantiated.localTrad.rules.isBox)
			{
				mySquarePreview = PreviewManager.Instance.GetSquarePreview();
				mySquarePreview.gameObject.SetActive(false);
			}
			else
			{
				myCirclePreview = PreviewManager.Instance.GetCirclePreview(transform);
				myCirclePreview.gameObject.SetActive(false);
			}
		}

	}

	protected override void ResolveSpell ()
	{
		print("I Resolve");
		base.ResolveSpell();
		Vector3 posToInstantiate = transform.position;

		if (spawnOnPos)
			posToInstantiate = transform.position;
		else
		{
			if (aoeInstantiated.localTrad.rules.isBox)
				posToInstantiate += transform.forward * aoeInstantiated.localTrad.rules.boxDimension.z / 2;
			else
				posToInstantiate += transform.forward * aoeInstantiated.localTrad.rules.aoeRadius;
		}

		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeInstantiated.gameObject), posToInstantiate, transform.rotation.eulerAngles);
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();
		if (aoeInstantiated.localTrad.rules.isBox)
		{
			mySquarePreview.gameObject.SetActive(true);
			mySquarePreview.Init(aoeInstantiated.localTrad.rules.boxDimension.z, aoeInstantiated.localTrad.rules.boxDimension.x, transform.eulerAngles.y, SquarePreview.squareCenter.center, transform.position + myPlayerModule.directionOfTheMouse() * aoeInstantiated.localTrad.rules.boxDimension.z / 2);
		}
	}

	protected override void HidePreview ( Vector3 _posToHide )
	{
		base.HidePreview(_posToHide);
		if (aoeInstantiated.localTrad.rules.isBox)
		{
			mySquarePreview.gameObject.SetActive(false);
		}
		else
			myCirclePreview.gameObject.SetActive(false);
	}

	
}

