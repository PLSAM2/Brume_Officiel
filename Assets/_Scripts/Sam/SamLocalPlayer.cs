using DarkRift;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SamLocalPlayer : MonoBehaviour
{
    public ushort myPlayerId;
    public bool isOwer = false;

    public PlayerModule myPlayerModule;

    Vector3 lastPosition;
    Vector3 lastRotation;

    //
    UnityClient currentClient;

    [SerializeField] Animator myAnimator;

    private void Awake()
    {
        lastPosition = transform.position;
        lastRotation = transform.localEulerAngles;
    }

    public void Init(UnityClient newClient)
    {
        currentClient = newClient;
        if (isOwer)
        {
            SamGameManager.Instance.myCam.m_Follow = transform;
            myPlayerModule.enabled = true;
        }
    }

    void Update()
    {
        if (!isOwer) { return; }

        if (Vector3.Distance(lastPosition, transform.position) > 0.2f || lastRotation != transform.localEulerAngles)
        {
            lastPosition = transform.position;
            lastRotation = transform.localEulerAngles;

            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(transform.position.x);
                _writer.Write(transform.position.z);

                _writer.Write(transform.localEulerAngles.x);
                _writer.Write(transform.localEulerAngles.y);
                _writer.Write(transform.localEulerAngles.z);

                using (Message _message = Message.Create(Tags.MovePlayerTag, _writer))
                {
                    currentClient.SendMessage(_message, SendMode.Unreliable);
                }
            }
        }
    }

    public void SetMovePosition(Vector3 newPos, Vector3 newRotation)
    {
        transform.position = newPos;
        transform.localEulerAngles = newRotation;
        myAnimator.SetFloat("Forward", 1, 0.1f, Time.deltaTime);
    }
}
