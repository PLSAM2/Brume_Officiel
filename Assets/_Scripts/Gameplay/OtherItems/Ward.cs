using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Ward : MonoBehaviour
{
    [SerializeField] private float lifeTime = 60;
    [SerializeField] private float lifeTimeAcceleratorInBrume = 10;
    public Fow vision;
    [SerializeField] private LayerMask brumeLayer;
    private Team myTeam;

    public bool isInBrume = false;
    public int brumeId;

    private bool landed = false;
    private float timer = 0;

    [SerializeField] GameObject mesh;
    [SerializeField] Transform rangePreview;

    Waypoint myWaypoint;
    [SerializeField] GameObject prefabWaypoint;

    [SerializeField] float timePingDisplay = 2;
    [SerializeField] float cdPing = 5;

    private void Awake()
    {
        //myWaypoint = Instantiate(prefabWaypoint, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
    }

    private void FixedUpdate()
    {
        if (landed)
        {
            if (isInBrume)
            {
                timer -= Time.fixedDeltaTime * lifeTimeAcceleratorInBrume;
            } else
            {
                timer -= Time.fixedDeltaTime;
            }


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
            vision.Init();
            timer = lifeTime;
            isInBrume = IsInBrume();

            GameManager.Instance.allWard.Add(this);
            GameManager.Instance.OnWardTeamSpawn?.Invoke(this);

            isInBrume = IsInBrume();

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
            vision.gameObject.SetActive(isView);


            landed = true;

            rangePreview.localScale = new Vector3(vision.myFieldOfView.viewRadius, vision.myFieldOfView.viewRadius, vision.myFieldOfView.viewRadius);

            //myWaypoint.SetImageColor(GameFactory.GetColorTeam(_team));
        }
    }


    Coroutine currentPing;
    Dictionary<ushort, float> oldPing = new Dictionary<ushort, float>();

    public void PingPlayerInWard(ushort id)
    {
        if (!oldPing.ContainsKey(id) || oldPing[id] >= cdPing + GameManager.Instance.timer)
        {
            if (!oldPing.ContainsKey(id))
            {
                oldPing.Add(id, GameManager.Instance.timer);
            }
            else
            {
                oldPing[id] = GameManager.Instance.timer;
            }

            StartCoroutine(PingPlayer());
        }
    }

    IEnumerator PingPlayer()
    {
        //play sound + circle sound feedback


        myWaypoint.gameObject.SetActive(true);

        yield return new WaitForSeconds(timePingDisplay);

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
        RaycastHit hit;
        if (Physics.Raycast(transform.position + Vector3.up * 1, -Vector3.up, out hit, 10, brumeLayer))
        {
            brumeId = hit.transform.parent.parent.GetComponent<Brume>().GetInstanceID();
            return true;
        }

        return false;
    }

    private void OnEnable()
    {
        GetMesh().SetActive(false);
        vision.gameObject.SetActive(false);
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

            GameManager.Instance.allWard.Remove(this);
        }
    }
}
