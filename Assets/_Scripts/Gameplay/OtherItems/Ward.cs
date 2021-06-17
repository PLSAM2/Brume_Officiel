using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
using Sirenix.OdinInspector;
using DarkRift;

public class Ward : MonoBehaviour
{

	public NetworkedObject networkedObject;

	[TabGroup("Tweakable")]
	public Sc_Status statusToApply;

	public Fow vision;
	public Team myTeam;
	bool hasTriggered = false;

	public bool isInBrume = false;
	public int brumeId;

	[SerializeField] GameObject mesh;
	[SerializeField] Transform rangePreview;

	Waypoint myWaypoint;
	[SerializeField] GameObject prefabWaypoint;


	private void Awake ()
	{
		myWaypoint = Instantiate(prefabWaypoint, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
		myWaypoint.target = transform;
		//myWaypoint.SetImageColor(GameFactory.GetColorTeam(Team.red));
		myWaypoint.gameObject.SetActive(false);
	}

    private void OnEnable ()
	{
        mesh.SetActive(false);
		Landed(networkedObject.GetOwner().playerTeam);
	}

	public void Landed ( Team _team )
	{
		myTeam = _team;

		if (_team != NetworkManager.Instance.GetLocalPlayer().playerTeam && NetworkManager.Instance.GetLocalPlayer().playerTeam != Team.spectator)
		{
			this.gameObject.SetActive(false);
		}
		else if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator || _team == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			vision.myFieldOfView.OnPlayerEnterInFow += OnPlayerSpotted;
            vision.myFieldOfView.EnemySeen += OnEnnemyInChange;


            vision.gameObject.SetActive(true);
			vision.Init();

			hasTriggered = false;


			GameManager.Instance.allWard.Add(this);
			GameManager.Instance.OnWardTeamSpawn?.Invoke(this);

            mesh.SetActive(myTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam);

			rangePreview.localScale = new Vector3(vision.myFieldOfView.viewRadius, vision.myFieldOfView.viewRadius, vision.myFieldOfView.viewRadius);
		}
	}
	
	public Fow GetFow ()
	{
		return vision;
	}

	private void OnDisable ()
	{
		if (myTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			vision.gameObject.SetActive(false);
			rangePreview.localScale = Vector3.zero;
			GameManager.Instance.allWard.Remove(this);

			vision.myFieldOfView.OnPlayerEnterInFow -= OnPlayerSpotted;
            vision.myFieldOfView.EnemySeen -= OnEnnemyInChange;

            if (myWaypoint != null)
            {
                myWaypoint.gameObject.SetActive(false);
            }
		}

	}

	void OnPlayerSpotted ( LocalPlayer _playerSpot, bool _value )
	{
		if (_value == false || _playerSpot == null) { return; }

        if (!_playerSpot.IsInMyTeam(myTeam))
		{
            if (statusToApply != null)
			{
                DamagesInfos _temp = new DamagesInfos();
				List<Sc_Status> _toApply = new List<Sc_Status>();
				_toApply.Add(statusToApply);
				_temp.statusToApply = _toApply.ToArray();
				_playerSpot.DealDamages(_temp, transform);
			}

			//ping
			if (!hasTriggered)
			{
                if (!hasTriggered)
				{
					hasTriggered = true;
				}

				myWaypoint.gameObject.SetActive(true);
			}
		}
	}

    void OnEnnemyInChange(bool _value)
    {
        if (_value == true) { return; }

        hasTriggered = false;

        if(myWaypoint != null)
        {
            myWaypoint.gameObject.SetActive(false);
        }
    }
}
