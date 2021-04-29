using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetworkAnimationController : MonoBehaviour
{
    UnityClient client;

    public Animator animator;
    public float movementLerpSpeed = 1;
    public float maxDistanceBeforeTP = 3;
    [SerializeField] LocalPlayer myLocalPlayer;

    Vector3 networkPos;
    short networkRota = 0;
    Vector3 lerpPos;

    [SerializeField] float speedAnim = 4;

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
        networkPos = transform.position;
        lerpPos = transform.position;
    }
    private void OnDisable()
    {
        client.MessageReceived -= Client_MessageReceived;
    }

    private void Update()
    {
        if (!myLocalPlayer.isOwner)
        {
            if (!myLocalPlayer.myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
            {
                speedAnim = myLocalPlayer.myPlayerModule.characterParameters.movementParameters.movementSpeed - 0.1f;
            }
            else
            {
                speedAnim = myLocalPlayer.myPlayerModule.characterParameters.movementParameters.crouchingSpeed - 0.1f;
            }

            if (Vector3.Distance(transform.position, networkPos) > maxDistanceBeforeTP)
            {
                transform.position = networkPos;
                lerpPos = networkPos;
            }


            if (myLocalPlayer.myPlayerModule.HasState(En_CharacterState.StopInterpolate) || myLocalPlayer.myPlayerModule.HasState(En_CharacterState.ForcedMovement))
            {
                transform.position = networkPos;
                lerpPos = networkPos;
            }
            else
            {

                lerpPos = Vector3.MoveTowards(lerpPos, networkPos, Time.deltaTime * speedAnim * movementLerpSpeed);
                transform.position = lerpPos;
            }

            transform.eulerAngles = new Vector3(0, Mathf.Lerp(transform.eulerAngles.y, networkRota, Time.deltaTime * 10), 0);
        }

        DoAnimation();
    }

    public void SetMovePosition(Vector3 _newPos)
    {
        networkPos = _newPos;
    }

    public void SetRotation(short _rota)
    {
        networkRota = _rota;
    }

    Vector3 oldPos;
    Vector3 direction;
    private void DoAnimation()
    {
        Vector3 currentPos;
        if (myLocalPlayer.isOwner)
        {
            currentPos = transform.position;
        }
        else
        {
            //tp et dash
            if (Vector3.Distance(lerpPos, transform.position) > 4)
            {
                lerpPos = transform.position;
            }

            currentPos = lerpPos;
        }

        float velocityX = (currentPos.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (currentPos.z - oldPos.z) / Time.deltaTime;

        float speed = myLocalPlayer.myPlayerModule.characterParameters.movementParameters.movementSpeed;

        velocityX = velocityX / speed;
        velocityZ = velocityZ / speed;

        direction = new Vector3(velocityX, 0, velocityZ);

        float turn = CalculateAngle180_v3(transform.forward, direction);

        float foward = Vector3.Dot(transform.forward, direction);

        //si je bouge
        animator.SetBool("IsMoving", foward != 0);

        //si je recule
        if (foward < 0)
        {
            turn = -turn;
        }

        animator.SetFloat("Turn", turn);

        oldPos = currentPos;
    }


    float CalculateAngle180_v3(Vector3 fromDir, Vector3 toDir)
    {
        float angle = Quaternion.FromToRotation(fromDir, toDir).eulerAngles.y;
        if (angle > 180) { return angle - 360f; }
        return angle;
    }

    public void SetTriggerToAnim(string triggerName)
    {
        animator.SetTrigger(triggerName);
    }

    public void SetIntToAnim(string triggerName, ushort index)
    {
        animator.SetInteger(triggerName, (int)index);
    }


    public void SetBoolToAnim(string _triggerName, bool _value)
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
