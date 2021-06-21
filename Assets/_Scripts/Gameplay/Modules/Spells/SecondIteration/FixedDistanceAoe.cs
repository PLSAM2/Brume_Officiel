using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class FixedDistanceAoe : SpellModule
{
	public GameObject aoeInstantiated;
	SquarePreview mySquarePreview;
	CirclePreview myCirclePreview;
	public bool spawnOnPos = false;
	public float radius;
	public Vector3 previewSquare;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		if (isOwner)
		{
			if (radius==0)
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
		base.ResolveSpell();
		Vector3 posToInstantiate = transform.position;

		if (spawnOnPos)
			posToInstantiate = transform.position;
		else
		{
			if (radius == 0)
				posToInstantiate += transform.forward * previewSquare.z / 2;
			else
				posToInstantiate += transform.forward * radius;
		}

		NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeInstantiated.gameObject), posToInstantiate, transform.rotation.eulerAngles);
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();
		if (radius == 0)
		{
			mySquarePreview.gameObject.SetActive(true);
			mySquarePreview.Init(previewSquare.z, previewSquare.x, transform.eulerAngles.y, SquarePreview.squareCenter.center, transform.position + myPlayerModule.directionOfTheMouse() * previewSquare.z / 2);
		}
		else if(!spawnOnPos)
			myCirclePreview.Init(radius, CirclePreview.circleCenter.center, transform.position +transform.forward * radius);
		else
			myCirclePreview.Init(radius, CirclePreview.circleCenter.center, transform.position);
	}

	public override void HidePreview ( Vector3 _posToHide )
	{
		base.HidePreview(_posToHide);

		if (radius == 0)
		{
			mySquarePreview.gameObject.SetActive(false);
		}
		else
			myCirclePreview.gameObject.SetActive(false);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);

		if(canBeCast())
		{
			if (radius == 0)
			{
				mySquarePreview.gameObject.SetActive(true);
			}
			else
				myCirclePreview.gameObject.SetActive(true);
		}
	}

	public void DoOpacity (ParticleSystemRenderer _particleToLerp)
	{
		_particleToLerp.material.SetFloat("_Opacity", 0);
		_particleToLerp.material.DOFloat(1, "_Opacity", .3f);
	}
}

