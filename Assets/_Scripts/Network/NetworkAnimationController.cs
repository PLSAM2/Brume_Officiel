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

    [SerializeField] LocalPlayer myLocalPlayer;

    private void Awake()
    {
        if (RoomManager.Instance == null)
        {
            Debug.Log("NO ROOM MANAGER");
            return;
        }

        client = RoomManager.Instance.client;
        client.MessageReceived += Client_MessageReceived;

        oldPos = transform.position;
    }
    private void OnDisable()
    {
        client.MessageReceived -= Client_MessageReceived;
    }

	private void Update ()
	{
        DoAnimation();
    }

    Vector3 oldPos;
    [SerializeField] float speedAnim = 30;
    private void DoAnimation ()
    {
        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;

        float speed = myLocalPlayer.myPlayerModule.characterParameters.movementParameters.movementSpeed;

        velocityX = Mathf.Lerp(velocityX, Mathf.Clamp(velocityX / speed, -1, 1), Time.deltaTime * speedAnim);
        velocityZ = Mathf.Lerp(velocityZ, Mathf.Clamp(velocityZ / speed, -1, 1), Time.deltaTime * speedAnim);

        Vector3 pos = new Vector3(velocityX, 0, velocityZ);

        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        animator.SetFloat("Forward", forward);
        animator.SetFloat("Turn", right);

        oldPos = transform.position;
    }

    public void SetTriggerToAnim ( string triggerName )
    {
        animator.SetTrigger(triggerName);
    }

    public void SetIntToAnim ( string triggerName , ushort index)
    {
        animator.SetInteger(triggerName,(int) index);
    }


    public void SetBoolToAnim ( string _triggerName, bool _value )
    {
        animator.SetBool(_triggerName, _value);
    }

    private void Client_MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.SyncTrigger)
            {
                SyncTriggerInserver(sender, e);
            }
            if (message.Tag == Tags.SyncBoolean)
            {
                SyncBooleanInserver(sender, e);
            }            
            if (message.Tag == Tags.SyncFloat)
            {
                SyncFloatInserver(sender, e);
            }
            if (message.Tag == Tags.SyncInt)
            {
                SyncIntInserver(sender, e);
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
    }

    private void SyncTriggerInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id != myLocalPlayer.myPlayerId) // si l'on est pas le sender
                    return;

                string _trigger = reader.ReadString();

                animator.SetTrigger(_trigger);
            }
        }
    }

    public void SyncBoolean(string boolean, bool value, SendMode sendMode = SendMode.Reliable)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(boolean);
            _writer.Write(value);

            using (Message _message = Message.Create(Tags.SyncBoolean, _writer))
            {
                client.SendMessage(_message, sendMode);
            }
        }
    }

    private void SyncBooleanInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id != myLocalPlayer.myPlayerId) // si l'on est pas le sender
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

    public void SyncInt(string intName, ushort value, SendMode sendMode = SendMode.Reliable)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(client.ID);
            _writer.Write(intName);
            _writer.Write(value);

            using (Message _message = Message.Create(Tags.SyncInt, _writer))
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

                if (_id != myLocalPlayer.myPlayerId) // si l'on est pas le sender
                    return;

                string _floatName = reader.ReadString();
                float _value = reader.ReadSingle();

                animator.SetFloat(_floatName, _value);
            }
        }
    }

    private void SyncIntInserver(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();

                if (_id != myLocalPlayer.myPlayerId) // si l'on est pas le sender
                    return;

                string _intName = reader.ReadString();
                ushort _value = reader.ReadUInt16();

                animator.SetInteger(_intName, _value);
            }
        }
    }
}
