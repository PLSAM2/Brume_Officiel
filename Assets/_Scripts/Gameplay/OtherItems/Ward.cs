using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Ward : MonoBehaviour
{
    [SerializeField] private float lifeTime = 60;
    [SerializeField] private float lifeTimeInBrume = 3;
    [SerializeField] private float inBrumeRevealDistance = 2;
    [SerializeField] private Fow fowFollow;
    [SerializeField] private LayerMask brumeLayer;
    private Team myTeam;
    public void Landed(Team _team)
    {
        myTeam = _team;

        if (_team != RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            this.DestroyWard();
        }
        else
        {
            if (IsInBrume())
            {
            }
            else
            {

            }

            fowFollow.gameObject.SetActive(true);
            fowFollow.Init();
            StartCoroutine(WardLifeTime());

            GameManager.Instance.allWard.Add(this);

            if (GameManager.Instance.currentLocalPlayer != null && GameManager.Instance.currentLocalPlayer.myPlayerModule.isInBrume)
            {
                fowFollow.gameObject.SetActive(false);
            }
        }
    }

    public Fow GetFow()
    {
        return fowFollow;
    }

    public bool IsInBrume()
    {
        RaycastHit[] f = Physics.RaycastAll(transform.position, transform.up, 50, brumeLayer);

        if (f.Length > 0)
        {
            return true;
        }

        return false;
    }

    public List<LocalPlayer> GetClosestLocalPlayer()
    {
        List<LocalPlayer> _temp = new List<LocalPlayer>();

        foreach (LocalPlayer player in GameManager.Instance.networkPlayers.Values)
        {
            if (Vector3.Distance(this.gameObject.transform.position, player.gameObject.transform.position) < inBrumeRevealDistance)
            {
                _temp.Add(player);
            }
        }
        return _temp;
    }

    public void DestroyWard()
    {
        fowFollow.gameObject.SetActive(false);
        this.gameObject.SetActive(false);
    }
    IEnumerator WardLifeTime()
    {
        yield return new WaitForSeconds(lifeTime);
        DestroyWard();

    }

    private void OnDisable()
    {
        if (myTeam == RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            fowFollow.gameObject.SetActive(false);

            GameManager.Instance.allWard.Remove(this);
        }
    }
}
