using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static iconActionKF;
using static KillFeedManager;

public class KillFeedManager : MonoBehaviour
{
    private static KillFeedManager _instance;
    public static KillFeedManager Instance { get { return _instance; } }

    [SerializeField] GameObject prefabKillFeedElement;

    [SerializeField] Transform listKillFeedParent;

    List<KillFeedElement> allKillfeedElement = new List<KillFeedElement>();

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
        GameManager.Instance.OnPlayerDisconnect += OnPlayerDisconnect;
        GameManager.Instance.OnPlayerRespawn += OnPlayerRespawn;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerDisconnect -= OnPlayerDisconnect;
        GameManager.Instance.OnPlayerRespawn -= OnPlayerRespawn;
    }

    void OnPlayerDie(ushort idPlayerDie, ushort playerKiller)
    {
        KillFeedElement currentKilfeed = GetFreeElement();
        currentKilfeed.InitAction(GetPlayerData(playerKiller), actionKillfeed.Kill, GetPlayerData(idPlayerDie));
    }

    void OnPlayerRespawn(ushort idPlayer)
    {
        KillFeedElement currentKilfeed = GetFreeElement();
        currentKilfeed.InitAction(GetPlayerData(idPlayer), actionKillfeed.Revive, null);
    }

    void OnPlayerDisconnect(ushort idPlayer)
    {

    }

    void SpawnAction()
    {

    }

    void SpawnMessage(string messageText)
    {

    }

    KillFeedElement GetFreeElement()
    {
        foreach(KillFeedElement element in allKillfeedElement)
        {
            if (!element.gameObject.activeSelf)
            {
                element.gameObject.SetActive(true);
                return element;
            }
        }

        KillFeedElement newElement = Instantiate(prefabKillFeedElement, listKillFeedParent).GetComponent<KillFeedElement>();
        allKillfeedElement.Add(newElement);
        return newElement;
    }

    PlayerData GetPlayerData(ushort id)
    {
        return RoomManager.Instance.GetPlayerData(id);
    }
}