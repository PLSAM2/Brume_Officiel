using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class InteractibleObjectsManager : SerializedMonoBehaviour
{
    [BoxGroup("L'ORDRE DES TYPES EST IMPORTANT !")]
    public List<KeyInteractiblePair> interactibleList = new List<KeyInteractiblePair>();

    private List<Altar> altarList = new List<Altar>();

    UnityClient client;

    private void Awake()
    {
        if (RoomManager.Instance == null)
        {
            Debug.LogError("NO ROOM MANAGER");
            return;
        }

        client = RoomManager.Instance.client;

        InitInteractibleID();
    }
    void Start()
    {
        //if (RoomManager.Instance.GetLocalPlayer().IsHost)
        //{
        //    StartCoroutine(UnlockAltar());
        //}

        foreach (KeyInteractiblePair KeyInteractiblePair in interactibleList)
        {
            if (KeyInteractiblePair.interactible.GetType() == typeof(Altar))
            {
                altarList.Add((Altar)KeyInteractiblePair.interactible);
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
            if (message.Tag == Tags.FrogTimerElasped)
            {
                RespawnFrogTimerEndInServer(sender, e);
            }
        }
    }

    public void InitInteractibleID()
    {
        for (ushort i = 0; i < interactibleList.Count; i++)
        {
            interactibleList[i].Key = i;
            interactibleList[i].interactible.interactibleID = i;
        }
    }

    private void UnlockInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

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

                Interactible _interactible = interactibleList[_ID].interactible;
                _interactible.UpdateCaptured(_team);
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

                Interactible _interactible = interactibleList[_ID].interactible;

                (_interactible).UpdateTryCapture(_team);
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

                Interactible _interactible = interactibleList[_ID].interactible;

                (_interactible).ProgressInServer(progress);
            }
        }
    }


    private void RespawnFrogTimerEndInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                ((Frog)_interactible).RespawnFrog();
            }
        }
    }

    //private IEnumerator UnlockAltar()
    //{
    //    yield return new WaitForSeconds(firstAltarUnlockTime); 

    //    List<Altar> usableAltars = new List<Altar>();

    //    foreach (Altar altar in altarList)
    //    {
    //        if (!altar.isInteractable)
    //        {
    //            usableAltars.Add(altar);
    //        }
    //    }

    //    ushort _altarId = (ushort)Random.Range(0, usableAltars.Count);
    //    Altar _altar = usableAltars[_altarId];

    //    if (_altar != null)
    //    {
    //        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
    //        {
    //            _writer.Write(_altarId);

    //            using (Message _message = Message.Create(Tags.UnlockInteractible, _writer))
    //            {
    //                client.SendMessage(_message, SendMode.Reliable);
    //            }
    //        }

    //        _altar.SetActiveState(true);
    //    }
    //}



}
