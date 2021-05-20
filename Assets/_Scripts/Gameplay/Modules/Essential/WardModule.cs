using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WardModule : SpellModule
{
	[SerializeField] private GameObject wardPrefab;

	public List<Ward> wards = new List<Ward>();

	CirclePreview myRangePreview, myAoePreview;
	float wardVisionRange;



	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);

		wardVisionRange = wardPrefab.GetComponent<Ward>().vision.myFieldOfView.viewRadius;

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			myAoePreview = PreviewManager.Instance.GetCirclePreview(transform);
			myAoePreview.Init(wardVisionRange, 0, myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(transform.position, myPlayerModule.mousePos()), 0, spell.range));

			myRangePreview = PreviewManager.Instance.GetCirclePreview(transform);
			myRangePreview.Init(spell.range, CirclePreview.circleCenter.center, Vector3.zero);

			HidePreview(Vector3.zero);
		}
	}



	protected override void Resolution ()
	{
		base.Resolution();

		Vector3 destination = TryToFindFreePos(mousePosInputed, 0);

		NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(13, destination, Vector3.zero);

	}


	//public void WardLanded ()
	//{
	//	isLaunched = false;

	//	if (myPlayerModule.mylocalPlayer.isOwner)
	//	{
	//		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
	//		{
	//			_writer.Write(RoomManager.Instance.client.ID); // Player ID

	//			using (Message _message = Message.Create(Tags.StartWardLifeTime, _writer))
	//			{
	//				RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
	//			}
	//		}
	//	}

	//	wardObj.GetComponent<Ward>().Landed(GetComponent<PlayerModule>().teamIndex);
	//}

	protected override void HidePreview ( Vector3 _posToHide )
	{
		base.HidePreview(_posToHide);

		myAoePreview.gameObject.SetActive(false);
		myRangePreview.gameObject.SetActive(false);
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);
		if (canBeCast())
		{
			myAoePreview.gameObject.SetActive(true);
			myRangePreview.gameObject.SetActive(true);
		}
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();
		myAoePreview.Init(wardVisionRange, CirclePreview.circleCenter.center,
			transform.position + myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(transform.position, myPlayerModule.mousePos()), 0, spell.range));

		myRangePreview.Init(spell.range, CirclePreview.circleCenter.center, transform.position);
	}

	Vector3 TryToFindFreePos ( Vector3 _locationToFindFrom, int _iteration )
	{
		Collider[] _hits;
		Vector3 posToCheck = _locationToFindFrom + (transform.position - _locationToFindFrom).normalized * _iteration * .6f;

		_hits = Physics.OverlapCapsule(posToCheck + Vector3.down * 10,
			posToCheck + Vector3.up * 10,
			.6f,
			1 << 9);

		Debug.DrawLine(posToCheck + Vector3.down * 10,
			posToCheck + Vector3.up * 10,
			Color.red,
			100);

		if (_hits.Length == 0)
		{
			return posToCheck;
		}
		else
		{

			posToCheck = _locationToFindFrom - (transform.position - _locationToFindFrom).normalized * _iteration * .6f;
			_hits = Physics.OverlapCapsule(posToCheck + Vector3.down * 10,
			posToCheck + Vector3.up * 10,
			.6f,
			1 << 9);

			Debug.DrawLine(posToCheck + Vector3.down * 10,
						posToCheck + Vector3.up * 10,
						Color.red,
						100);

			if (_hits.Length == 0)
			{
				return posToCheck;
			}
			else
				return TryToFindFreePos(_locationToFindFrom, _iteration + 1);
		}
	}

}
