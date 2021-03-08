﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class PingObject : MonoBehaviour
{
    public float lifeTime = 3;
    public List<SpriteRenderer> sprites = new List<SpriteRenderer>();
    public NetworkedObject networkedObject;
    public AudioSource audioSource;

    [SerializeField] GameObject waypointPrefab;
    Waypoint waypointObj;

    private void OnEnable()
    {
        Init(networkedObject.GetOwner().playerTeam);
    }
    public void Init(Team team)
    {
        if (team != NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            this.gameObject.SetActive(false);
        } else
        {

            if (waypointObj)
            {
                Destroy(waypointObj.gameObject);
            }

            waypointObj = Instantiate(waypointPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
            waypointObj.target = transform;

            if (audioSource != null)
            {
                audioSource.Play();
            }
            StartCoroutine(AutoKillTime());
        }
    }

    IEnumerator AutoKillTime()
    {
        yield return new WaitForSeconds(lifeTime);

        Destroy(waypointObj.gameObject);
        this.gameObject.SetActive(false);
    }
}
