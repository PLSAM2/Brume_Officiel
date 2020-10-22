using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

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
            if (message.Tag == Tags.TryCaptureInteractible)
            {
                TryCaptureAltarInServer(sender, e);
            }
            if (message.Tag == Tags.CaptureProgressInteractible)
            {
                CaptureProgressAltarInServer(sender, e);
            }            
            if (message.Tag == Tags.CaptureInteractible)
            {
                CaptureAltarInServer(sender, e);
            }
            if (message.Tag == Tags.UnlockInteractible)
            {
                UnlockAltarInServer(sender, e);
            }
        }
    }

    private void UnlockAltarInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _altarID = reader.ReadUInt16();

                Altar _altar = altarList[_altarID];

                _altar.SetActiveState(true);
            }
        }
    }

    private void CaptureAltarInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _altarID = reader.ReadUInt16();
                Team _team = (Team)reader.ReadUInt16();

                Altar _altar = altarList[_altarID];

                _altar.UpdateCaptured(_team);
            }
        }
    }

    private void TryCaptureAltarInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _altarID = reader.ReadUInt16();
                Team _team = (Team)reader.ReadUInt16();

                Altar _altar = altarList[_altarID];

                _altar.UpdateTryCapture(_team);
            }
        }

    }

    private void CaptureProgressAltarInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _altarID = reader.ReadUInt16();
                float progress = reader.ReadSingle();

                Altar _altar = altarList[_altarID];

                _altar.ProgressInServer(progress);
            }


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

        ushort _altarId = (ushort)Random.Range(0, usableAltars.Count);
        Altar _altar = usableAltars[_altarId];

        if (_altar != null)
        {
            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(_altarId);

                using (Message _message = Message.Create(Tags.UnlockInteractible, _writer))
                {
                    client.SendMessage(_message, SendMode.Reliable);
                }
            }

            _altar.SetActiveState(true);
        }
    }



}
