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
    [SerializeField] GameObject prefabKillFeedTextElement;

    [SerializeField] Transform listKillFeedParent;

    List<KillFeedElement> allKillfeedElement = new List<KillFeedElement>();
    List<KillFeedElementText> allKillfeedElementText = new List<KillFeedElementText>();

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
        NetworkManager.Instance.OnPlayerQuit += OnPlayerDisconnect;
        GameManager.Instance.OnPlayerRespawn += OnPlayerRespawn;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        NetworkManager.Instance.OnPlayerQuit -= OnPlayerDisconnect;
        GameManager.Instance.OnPlayerRespawn -= OnPlayerRespawn;
    }

    public bool test = false;
    public ushort id = 0;
    private void Update()
    {
        if (test)
        {
            test = false;

            OnPlayerDie(id, id);
        }
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

    void OnPlayerDisconnect(PlayerData player)
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
                element.transform.parent = null;
                element.transform.SetParent(listKillFeedParent);
                return element;
            }
        }

        KillFeedElement newElement = Instantiate(prefabKillFeedElement, listKillFeedParent).GetComponent<KillFeedElement>();
        allKillfeedElement.Add(newElement);
        return newElement;
    }

    KillFeedElementText GetFreeElementText()
    {
        foreach (KillFeedElementText element in allKillfeedElementText)
        {
            if (!element.gameObject.activeSelf)
            {
                element.gameObject.SetActive(true);
                element.transform.parent = null;
                element.transform.SetParent(listKillFeedParent);
                return element;
            }
        }

        KillFeedElementText newElement = Instantiate(prefabKillFeedTextElement, listKillFeedParent).GetComponent<KillFeedElementText>();
        allKillfeedElementText.Add(newElement);
        return newElement;
    }

    PlayerData GetPlayerData(ushort id)
    {
        if(id == null)
        {
            return null;
        }

        return RoomManager.Instance.GetPlayerData(id);
    }
}