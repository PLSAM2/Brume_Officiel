using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetworkAnimationController : MonoBehaviour
{
    UnityClient client;

    [SerializeField] Animator animator;

    private void Awake()
    {
        if (RoomManager.Instance == null)
        {
            Debug.Log("NO ROOM MANAGER");
            return;
        }

        if (animator == null)
        {
            animator = GetComponent<Animator>();
        }

        client = RoomManager.Instance.client;
        client.MessageReceived += Client_MessageReceived;
    }

    private void Client_MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SyncTrigger)
            {
                SyncTrigger(sender, e);
            }
        }
    }

    public void SyncTrigger(string trigger)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(trigger);

            using (Message _message = Message.Create(Tags.SyncTrigger, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }

        animator.SetTrigger(trigger);
    }


    private void SyncTrigger(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();
                string _trigger = reader.ReadString();

                if (_id == client.ID && RoomManager.Instance.client.ID != _id) // SI ce player est bien le sender + si l'on est pas le sender
                {
                    animator.SetTrigger(_trigger);
                }

            }
        }
    }
}
