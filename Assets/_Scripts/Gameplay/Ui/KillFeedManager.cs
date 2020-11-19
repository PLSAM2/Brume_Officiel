using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static KillFeedManager;

public class KillFeedManager : MonoBehaviour
{
    private static KillFeedManager _instance;
    public static KillFeedManager Instance { get { return _instance; } }

    [SerializeField] GameObject prefabIconPerso;

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
    }

    void OnPlayerDie(ushort idPlayerDie, ushort playerKiller)
    {

    }
}