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

            isInBrume = IsInBrume();

            GameManager.Instance.allWard.Add(this);
            GameManager.Instance.OnWardTeamSpawn?.Invoke(this);

            vision.gameObject.SetActive(false);

            if (GameFactory.PlayerWardAreOnSameBrume(GameFactory.GetActualPlayerFollow().myPlayerModule,this))
            {
                vision.gameObject.SetActive(true);
            }

            if (!GameFactory.GetActualPlayerFollow().myPlayerModule.isInBrume && !isInBrume){
                vision.gameObject.SetActive(true);
            }

            if (!GameFactory.GetActualPlayerFollow().myPlayerModule.isInBrume && isInBrume)
            {
                vision.gameObject.SetActive(true);
            }

            timer = lifeTime;
            landed = true;
        }
    }

    public Fow GetFow()
    {
        return vision;
    }

    public bool IsInBrume()
    {
        RaycastHit hit;
        if(Physics.Raycast(transform.position, Vector3.up, out hit, Mathf.Infinity, brumeLayer)){
            brumeId = hit.transform.GetChild(0).GetComponent<Brume>().GetInstanceID();
            return true;
        }

        return false;
    }

    public void DestroyWard()
    {
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
