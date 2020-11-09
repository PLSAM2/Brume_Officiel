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

        client = RoomManager.Instance.client;
        client.MessageReceived += Client_MessageReceived;
    }
    private void OnDisable()
    {
        client.MessageReceived -= Client_MessageReceived;
    }


    private void Client_MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SyncTrigger)
            {
                SyncTriggerInserver(sender, e);
            }
            if (message.Tag == Tags.Sync2DBlendTree)
            {
                Sync2DBlendTreeInserver(sender, e);
            }
            if (message.Tag == Tags.SyncBoolean)
            {
                SyncBooleanInserver(sender, e);
            }            
            if (message.Tag == Tags.SyncFloat)
            {
                SyncFloatInserver(sender, e);
            }
        }
    }

    public void SyncTrigger(string trigger, SendMode sendMode = SendMode.Reliable)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(trigger);

            using (Message _message = Message.Create(Tags.SyncTrigger, _writer))
            {
                client.SendMessage(_message, sendMode);
            }
        }

        animator.SetTrigger(trigger);
    }

    private void SyncTriggerInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id == client.ID) // si l'on est pas le sender
                    return;

                string _trigger = reader.ReadString();

                animator.SetTrigger(_trigger);
            }
        }
    }

    public void Sync2DBlendTree(string XvalueName, string YvalueName, float Xvalue, float Yvalue, SendMode sendMode = SendMode.Reliable)
    {
        sbyte optimisedXvalue = (sbyte)Mathf.RoundToInt(Xvalue * 100);
        sbyte optimisedYvalue = (sbyte)Mathf.RoundToInt(Yvalue * 100);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(XvalueName);
            _writer.Write(YvalueName);
            _writer.Write(optimisedXvalue);
            _writer.Write(optimisedYvalue);

            using (Message _message = Message.Create(Tags.Sync2DBlendTree, _writer))
            {
                client.SendMessage(_message, sendMode);
            }
        }
    }
    private void Sync2DBlendTreeInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id == client.ID) // si l'on est pas le sender
                    return;

                string XvalueName = reader.ReadString();
                string YvalueName = reader.ReadString();
                float Xvalue = ((float)reader.ReadSByte()) / 100;
                float Yvalue = ((float)reader.ReadSByte()) / 100;

                animator.SetFloat(XvalueName, Xvalue);
                animator.SetFloat(YvalueName, Yvalue);


            }
        }
    }

    public void SyncFloatInServer(string boolean, bool value, SendMode sendMode = SendMode.Reliable)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(boolean);
            _writer.Write(value);

            using (Message _message = Message.Create(Tags.SyncTrigger, _writer))
            {
                client.SendMessage(_message, sendMode);
            }
        }

        animator.SetBool(boolean, value);
    }

    private void SyncBooleanInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id == client.ID) // si l'on est pas le sender
                    return;

                string _boolean = reader.ReadString();
                bool _value = reader.ReadBoolean();

                animator.SetBool(_boolean, _value);
            }
        }
    }
    public void SyncFloat(string floatName, float value, SendMode sendMode = SendMode.Reliable)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(floatName);
            _writer.Write(value);

            using (Message _message = Message.Create(Tags.SyncFloat, _writer))
            {
                client.SendMessage(_message, sendMode);
            }
        }
    }

    private void SyncFloatInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id == client.ID) // si l'on est pas le sender
                    return;

                string _floatName = reader.ReadString();
                float _value = reader.ReadSingle();

                animator.SetFloat(_floatName, _value);
            }
        }
    }
}
