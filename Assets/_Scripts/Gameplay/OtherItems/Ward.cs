﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
using Sirenix.OdinInspector;
public class Ward : MonoBehaviour
{
    [TabGroup("Tweakable")]
    [SerializeField] private float lifeTime = 30;
    [TabGroup("Tweakable")] [SerializeField] private float lifeTimeInBrume = 7;
    [TabGroup("Tweakable")] public float wardLifeDurationOnSpot;
    public Sc_Status statusToApply;

    public Fow vision;
    [SerializeField] private LayerMask brumeLayer;
    private Team myTeam;
    bool asTriggered = false;

    public bool isInBrume = false;
    public int brumeId;
    private bool landed = false;
    private float timer = 0;

    [SerializeField] GameObject mesh;
    [SerializeField] Transform rangePreview;

    Waypoint myWaypoint;
    [SerializeField] GameObject prefabWaypoint;
    Coroutine currentPing;
    Dictionary<ushort, float> oldPing = new Dictionary<ushort, float>();

    private void Awake()
    {
        myWaypoint = Instantiate(prefabWaypoint, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        myWaypoint.target = transform;
        myWaypoint.SetImageColor(GameFactory.GetColorTeam(Team.red));
        myWaypoint.gameObject.SetActive(false);
    }



    private void FixedUpdate()
    {
        if (landed)
        {
            timer -= Time.fixedDeltaTime;

            if (timer <= 0)
            {
                DestroyWard();
            }

        }
    }

    public void Landed(Team _team)
    {
        myTeam = _team;

        if (_team != NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            this.DestroyWard();
        }
        else
        {
            vision.gameObject.SetActive(true);
            vision.Init();

            isInBrume = IsInBrume();

            asTriggered = false;

            if (isInBrume)
                timer = lifeTimeInBrume;
            else
                timer = lifeTime;

            GameManager.Instance.allWard.Add(this);
            GameManager.Instance.OnWardTeamSpawn?.Invoke(this);


            bool isView = false;
            if (GameFactory.GetActualPlayerFollow().myPlayerModule.isInBrume == this.isInBrume)
            {
                if (GameFactory.PlayerWardAreOnSameBrume(GameFactory.GetActualPlayerFollow().myPlayerModule, this) || isInBrume == false)
                {
                    isView = true;
                }
                else
                {
                    isView = false;
                }
            }

            GetMesh().SetActive(isView);
            //vision.gameObject.SetActive(isView);


            landed = true;

            rangePreview.localScale = new Vector3(vision.myFieldOfView.viewRadius, vision.myFieldOfView.viewRadius, vision.myFieldOfView.viewRadius);

            //myWaypoint.SetImageColor(GameFactory.GetColorTeam(_team));
        }
    }

    internal void InitWardLaunch()
    {
        if (myTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            rangePreview.localScale = Vector3.zero;
            vision.gameObject.SetActive(false);
        }
    }


    public void PingWard()
    {
        StartCoroutine(PingPlayer());
    }

    IEnumerator PingPlayer()
    {
        myWaypoint.gameObject.SetActive(true);
        lifeTime = wardLifeDurationOnSpot;
        yield return new WaitForSeconds(wardLifeDurationOnSpot);
        myWaypoint.gameObject.SetActive(false);
    }

    public Fow GetFow()
    {
        return vision;
    }

    public GameObject GetMesh()
    {
        return mesh;
    }

    bool IsInBrume()
    {
        if (Physics.Raycast(transform.position, Vector3.up, 100, brumeLayer))
        {
            return true;
        }

        return false;
    }

    private void OnEnable()
    {
        if (myTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            rangePreview.localScale = Vector3.zero;
            vision.myFieldOfView.OnPlayerEnterInFow += OnPlayerSpotted;
        }

        GetMesh().SetActive(false);
    }

    public void DestroyWard()
    {
        landed = false;
        vision.gameObject.SetActive(false);
        this.gameObject.SetActive(false);
    }

    private void OnDisable()
    {
        if (myTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            vision.gameObject.SetActive(false);
            rangePreview.localScale = Vector3.zero;
            GameManager.Instance.allWard.Remove(this);

            vision.myFieldOfView.OnPlayerEnterInFow -= OnPlayerSpotted;
            myWaypoint.gameObject.SetActive(false);
        }
    }

    void OnPlayerSpotted(LocalPlayer _playerSpot, bool _value)
    {
        if(_value == false) { return; }

        if (!_playerSpot.IsInMyTeam(myTeam) && myTeam == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
        {
            if (statusToApply != null)
            {
                DamagesInfos _temp = new DamagesInfos();
                List<Sc_Status> _toApply = new List<Sc_Status>();
                _toApply.Add(statusToApply);
                _temp.statusToApply = _toApply.ToArray();
                _playerSpot.DealDamages(_temp, transform.position);
            }
            //ping
            if (!asTriggered)
            {
                asTriggered = true;
                myWaypoint.gameObject.SetActive(true);
                PingWard();
            }
        }
    }
}
