using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class InteractibleObjectsManager : MonoBehaviour
{
    [BoxGroup]
    [InfoBox("Chaque objet doit avoir un ID UNIQUE", InfoMessageType.Info)]
    public List<Interactible> interactibleList = new List<Interactible>();

    private List<Altar> altarList = new List<Altar>();
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

        foreach (Interactible interactible in interactibleList)
        {
            if (interactible.GetType() == typeof(Altar))
            {
                altarList.Add((Altar)interactible);
            }
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
                TryCaptureInteractibleInServer(sender, e);
            }
            if (message.Tag == Tags.CaptureProgressInteractible)
            {
                CaptureProgressInteractibleInServer(sender, e);
            }            
            if (message.Tag == Tags.CaptureInteractible)
            {
                CaptureInteractibleInServer(sender, e);
            }
            if (message.Tag == Tags.UnlockInteractible)
            {
                UnlockInteractibleInServer(sender, e);
            }
        }
    }

    private void UnlockInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID];

                if (_interactible.GetType() == typeof(Altar))
                {
                    ((Altar)_interactible).SetActiveState(true);
                }
            }
        }
    }

    private void CaptureInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                Team _team = (Team)reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID];

                if (_interactible.GetType() == typeof(Altar))
                {
                    ((Altar)_interactible).UpdateCaptured(_team);
                }
            }
        }
    }

    private void TryCaptureInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                Team _team = (Team)reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID];


                if (_interactible.GetType() == typeof(Altar))
                {
                    ((Altar)_interactible).UpdateTryCapture(_team);
                }
            }
        }

    }

    private void CaptureProgressInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                float progress = reader.ReadSingle();

                Interactible _interactible = interactibleList[_ID];

                if (_interactible.GetType() == typeof(Altar))
                {
                    ((Altar)_interactible).ProgressInServer(progress);
                }
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
