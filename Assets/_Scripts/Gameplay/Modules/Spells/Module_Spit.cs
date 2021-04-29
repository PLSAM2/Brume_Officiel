using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using Sirenix.OdinInspector;
using static AOE_Fx;

public class Module_Spit : SpellModule
{

	public GameObject spitTravelPrefab;
	//NEED CLEAN OLD SYSTEM
	public float deceleratedRatio = 1; // Plus il est petit, plus la vitesse de l'objet lorsqu'il est haut est lent
	public float distanceMaxBeforeEndTravel = 0.01f;


	private bool isLaunched = false;
	private float deceleration = 1;
	private float baseDistance;
	private float lastOffest = 0;
	private Vector3 startPos;
	private Vector3 destination;
	private Vector3 noCurvePosition;
	private float animationCurveMaxValue;

	Sc_Spit localTrad;
	[SerializeField] bool simpleSpeed = false;

	CirclePreview myRangePreview, myAoePreview;

	float initialDistance, percentageStrengthOfTheThrow;
	Vector3 finalPos;



	public override void SetupComponent ( En_SpellInput _actionLinked )
	{

		base.SetupComponent(_actionLinked);

		localTrad = spell as Sc_Spit;

		animationCurveMaxValue = localTrad.launchCurve.Evaluate(0.5f); // MaxValue généré sur le millieu de la curve

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			myAoePreview = PreviewManager.Instance.GetCirclePreview(transform);
			myAoePreview.Init(localTrad.radiusOfImpact, 0, myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(transform.position, myPlayerModule.mousePos()), 0, spell.range));

			//myAoePreview.
			myRangePreview = PreviewManager.Instance.GetCirclePreview(transform);
			myRangePreview.Init(spell.range, CirclePreview.circleCenter.center, Vector3.zero);

			HidePreview(Vector3.zero);
		}

	}


	protected override void ResolveSpell ()
	{
		base.ResolveSpell();

		Landed();

		/*
		float finalRange = 0;
		finalRange = Mathf.Clamp(Vector3.Distance(transform.position, mousePosInputed), 0, spell.range);
		Vector3 direction = new Vector3();
		direction = Vector3.Normalize(mousePosInputed - transform.position);

		destination = transform.position + direction * finalRange;

		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(RoomManager.Instance.client.ID); // Player ID

			_writer.Write(destination.x);
			_writer.Write(destination.y);
			_writer.Write(destination.z);

			using (Message _message = Message.Create(Tags.CurveSpellLaunch, _writer))
			{
				RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
			}
		}

		InitLaunch(destination);*/
	}

	/*public void InitLaunch ( Vector3 destination )
	{
		initialDistance = Vector3.Distance(transform.position, destination);
		finalPos = destination;

		percentageStrengthOfTheThrow = initialDistance / spell.range;


		if (!simpleSpeed)
		{

			spitObj.transform.position = transform.position + Vector3.up;
			isLaunched = true;
			float timeToReach = Mathf.Clamp(percentageStrengthOfTheThrow * localTrad.timeToReachMaxRange, localTrad.minTimeToReach, localTrad.timeToReachMaxRange);
			spitObj.transform.DOMoveX(destination.x, timeToReach).OnComplete(() => Landed());
			spitObj.transform.DOMoveZ(destination.z, timeToReach);

			//LocalPoolManager.Instance.SpawnNewAOEInNetwork(myPlayerModule.mylocalPlayer.myPlayerId, destination, localTrad.radiusOfImpact, timeToReach);
		}
		else
		{
			this.destination = destination;
			startPos = (transform.position + Vector3.up);
			spitObj.transform.position = startPos;
			baseDistance = Vector3.Distance(startPos, destination);
			noCurvePosition = startPos;
			isLaunched = true;
		}
	}
	*/
	public void Landed ()
	{
		isLaunched = false;
		//spitObj.SetActive(false);

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			using (DarkRiftWriter _writer = DarkRiftWriter.Create())
			{
				_writer.Write(RoomManager.Instance.client.ID); // Player ID

				using (Message _message = Message.Create(Tags.CurveSpellLanded, _writer))
				{
					RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
				}
			}

			NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(NetworkObjectsManager.Instance.GetPoolID(localTrad.onImpactInstantiate.gameObject), destination, transform.rotation.eulerAngles);
		}
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
		myAoePreview.Init(localTrad.radiusOfImpact, CirclePreview.circleCenter.center, 
			transform.position + myPlayerModule.directionOfTheMouse() * Mathf.Clamp(Vector3.Distance(transform.position, myPlayerModule.mousePos()), 0, spell.range));

		myRangePreview.Init(spell.range, CirclePreview.circleCenter.center, transform.position);
	}
}
