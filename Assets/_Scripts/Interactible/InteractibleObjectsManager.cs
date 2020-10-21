using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractibleObjectsManager : MonoBehaviour
{
    public List<Altar> altarList = new List<Altar>();
    public float firstAltarUnlockTime = 15;

     UnityClient client;


    private void Awake()
    {
        if (RoomManager.Instance == null)
        {
            Debug.LogError("NO ROOM MANAGER");
            return;
        }

        client = RoomManager.Instance.client;

    }
    void Start()
    {
        if (RoomManager.Instance.GetLocalPlayer().IsHost)
        {
            StartCoroutine(UnlockAltar());
        }

        client.MessageReceived += MessageReceived;
    }

    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
    }


    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {

        }
    }

    private IEnumerator UnlockAltar()
    {
        yield return new WaitForSeconds(firstAltarUnlockTime);

        List<Altar> usableAltars = new List<Altar>();

        foreach (Altar altar in altarList)
        {
            if (!altar.isInteractable)
            {
                usableAltars.Add(altar);
            }
        }

        Altar _altar = usableAltars[Random.Range(0, usableAltars.Count)];

        if (_altar != null)
        {
            _altar.SetActiveState(true);
        }

    }
}
