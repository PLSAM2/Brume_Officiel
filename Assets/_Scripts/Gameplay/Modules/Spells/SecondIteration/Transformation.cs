using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Transformation : SpellModule
{
	public SpellModule newClick, newFirst, newSecond, newThird;
	public Aoe aoeToInstantiate;
	CirclePreview myPreview;
	public GameObject objectToShow;
	bool asTransformed = false;
	private void Start ()
	{
		if (aoeToInstantiate != null)
		{
			myPreview = PreviewManager.Instance.GetCirclePreview(transform);
			myPreview.Init(aoeToInstantiate.localTrad.rules.aoeRadius, CirclePreview.circleCenter.center, transform.position);
			HidePreview(Vector3.zero);
		}
		objectToShow.SetActive(false);

	}

	protected override void ResolveSpell ()
	{

		if (asTransformed)
		{
			NetworkObjectsManager.Instance.NetworkInstantiate(NetworkObjectsManager.Instance.GetPoolID(aoeToInstantiate.gameObject), transform.position, transform.rotation.eulerAngles);
		}

		base.ResolveSpell();
		if (newClick != null)
		{
			myPlayerModule.leftClick.Disable();
			SpellModule _temp = myPlayerModule.leftClick;
			newClick.SetupComponent(En_SpellInput.Click);
			myPlayerModule.leftClick = newClick;
			newClick = _temp;
		}
		if (newFirst != null)
		{
			myPlayerModule.firstSpell.Disable();
			SpellModule _temp = myPlayerModule.firstSpell;
			newFirst.SetupComponent(En_SpellInput.FirstSpell);
			myPlayerModule.firstSpell = newFirst;
			newFirst = _temp;
		}
		if (newSecond != null)
		{
			myPlayerModule.secondSpell.Disable();
			SpellModule _temp = myPlayerModule.secondSpell;
			newSecond.SetupComponent(En_SpellInput.SecondSpell);
			myPlayerModule.secondSpell = newSecond;
			newSecond = _temp;
		}
	}

	public override void HidePreview ( Vector3 _posToHide )
	{
		if (myPreview != null)
			myPreview.gameObject.SetActive(false);
		base.HidePreview(_posToHide);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (myPreview != null && canBeCast()) 
			myPreview.gameObject.SetActive(true);
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();
		if (myPreview != null)
			myPreview.Init(aoeToInstantiate.localTrad.rules.aoeRadius, CirclePreview.circleCenter.center, transform.position);
	}

	public override bool CanDeacreaseCooldown ()
	{
		return asTransformed;
	}

	public override void ResolutionFeedBack ()
	{
		asTransformed = !asTransformed;
		objectToShow.SetActive(asTransformed);

		base.ResolutionFeedBack();
	}
}
