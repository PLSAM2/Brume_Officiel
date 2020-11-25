using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Ward : MonoBehaviour
{
    [SerializeField] private float lifeTime = 60;
    [SerializeField] private float lifeTimeInBrume = 3;
    [SerializeField] private Fow vision;
    [SerializeField] private LayerMask brumeLayer;
    private Team myTeam;

    public bool isInBrume = false;
    public int brumeId;

    public void Landed(Team _team)
    {
        myTeam = _team;

        if (_team != RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            this.DestroyWard();
        }
        else
        {
            vision.Init();

            isInBrume = IsInBrume();
            if (isInBrume)
            {
                StartCoroutine(WardLifeTime(lifeTimeInBrume));
            }
            else
            {
                StartCoroutine(WardLifeTime(lifeTime));
            }

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
            brumeId = hit.transform.GetChild(0).GetComponent<BrumeScript>().GetInstanceID();
            return true;
        }

        return false;
    }

    public void DestroyWard()
    {
        vision.gameObject.SetActive(false);
        this.gameObject.SetActive(false);
    }
    IEnumerator WardLifeTime(float _time)
    {
        yield return new WaitForSeconds(_time);
        DestroyWard();

    }

    private void OnDisable()
    {
        if (myTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            vision.gameObject.SetActive(false);

            GameManager.Instance.allWard.Remove(this);
        }
    }
}
