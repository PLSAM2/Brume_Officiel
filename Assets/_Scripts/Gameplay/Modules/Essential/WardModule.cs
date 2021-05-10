using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WardModule : SpellModule
{
	[SerializeField] private GameObject wardPrefab;
	private GameObject wardObj;
	public float wardSpeed;

	public float distanceMaxBeforeEndTravel = 0.01f;
	private bool isLaunched = false;

	private Vector3 startPos;
	private Vector3 destination;

	CirclePreview myRangePreview, myAoePreview;
	float wardVisionRange;

	Vector3 lastPos = Vector3.zero;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);

		wardObj = Instantiate(wardPrefab, Vector3.zero, Quaternion.identity);
		wardObj.SetActive(false);
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



	protected override void Update ()
	{
		base.Update();
		if (isLaunched)
		{
			if (Vector3.Distance(wardObj.transform.position, destination) < distanceMaxBeforeEndTravel)
			{
				WardLanded();
				return;
			}

			lastPos = Vector3.MoveTowards(lastPos, destination, wardSpeed * Time.deltaTime);

			wardObj.transform.position = lastPos;
		}
	}

	protected override void Resolution (  )
	{
		if (isLaunched)
		{
			return;
		}

		base.Resolution();

		float _distance = Mathf.Clamp(Vector3.Distance(mousePosInputed, transform.position), 0, spell.range);

		destination = transform.position + myPlayerModule.directionOfTheMouse() * _distance;
			//myPlayerModule.ClosestFreePos(Vector3.Normalize(mousePosInputed - transform.position), _distance);

		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(RoomManager.Instance.client.ID); // Player ID

			_writer.Write(destination.x);
			_writer.Write(destination.y);
			_writer.Write(destination.z);

			using (Message _message = Message.Create(Tags.LaunchWard, _writer))
			{
				RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
			}
		}

		InitWardLaunch(destination);
	}

	public void InitWardLaunch ( Vector3 destination )
	{
		lastPos = this.transform.position;
		this.destination = destination;
		wardObj.SetActive(true);
		startPos = (transform.position);
		wardObj.transform.position = startPos;
		wardObj.GetComponent<Ward>().InitWardLaunch();
		isLaunched = true;
	}

	public void WardLanded ()
	{
		isLaunched = false;

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			using (DarkRiftWriter _writer = DarkRiftWriter.Create())
			{
				_writer.Write(RoomManager.Instance.client.ID); // Player ID

				using (Message _message = Message.Create(Tags.StartWardLifeTime, _writer))
				{
					RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
				}
			}
		}

		wardObj.GetComponent<Ward>().Landed(GetComponent<PlayerModule>().teamIndex);
	}

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

}
