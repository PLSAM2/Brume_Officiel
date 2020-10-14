using DarkRift;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class LocalPlayer : MonoBehaviour
{
    public ushort myPlayerId;
    public bool isOwer = false;

    public PlayerModule myPlayerModule;

    Vector3 lastPosition;
    Vector3 lastRotation;

    //
    UnityClient currentClient;

    [SerializeField] Animator myAnimator;

    [SerializeField] GameObject circleDirection;

    [Header("MultiGameplayParameters")]
    private uint _liveHealth;
    public Team teamIndex;

    [ReadOnly] public uint liveHealth { get => _liveHealth; set { _liveHealth = value; if (_liveHealth <= 0) KillPlayer(); } }


    private void Awake()
    {
        lastPosition = transform.position;
        lastRotation = transform.localEulerAngles;
        OnRespawn();
    }

    public void Init(UnityClient newClient)
    {
        currentClient = newClient;
        if (isOwer)
        {
            GameManager.Instance.myCam.m_Follow = transform;
            myPlayerModule.enabled = true;

            myPlayerModule.onSendMovement += OnPlayerMove;

            circleDirection.SetActive(true);
        }
    }

    private void OnDisable()
    {
        myPlayerModule.onSendMovement -= OnPlayerMove;
    }

    void Update()
    {
        if (!isOwer) { return; }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            NetworkObjectsManager.Instance.NetworkInstantiate(10, transform.position + Vector3.up, new Vector3(Random.Range(0, 360), 0, 0));
        }


        if (Vector3.Distance(lastPosition, transform.position) > 0.2f || lastRotation != transform.localEulerAngles)
        {
            lastPosition = transform.position;
            lastRotation = transform.localEulerAngles;

            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(RoomManager.Instance.actualRoom.ID);

                _writer.Write(transform.position.x);
                _writer.Write(transform.position.z);

                _writer.Write(transform.localEulerAngles.y);

                using (Message _message = Message.Create(Tags.MovePlayerTag, _writer))
                {
                    currentClient.SendMessage(_message, SendMode.Unreliable);
                }
            }
        }
    }

    void OnPlayerMove(Vector3 pos)
    {
        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        myAnimator.SetFloat("Forward", forward);
        myAnimator.SetFloat("Turn", right);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            _writer.Write(forward);
            _writer.Write(right);

            using (Message _message = Message.Create(Tags.SendAnim, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Unreliable);
            }
        }
    }

    public void SetAnim(float forward, float right)
    {
        print(forward);
        print(right);

        myAnimator.SetFloat("Forward", forward);
        myAnimator.SetFloat("Turn", right);
    }

    public void SetMovePosition(Vector3 newPos, Vector3 newRotation)
    {
        transform.position = newPos;
        transform.localEulerAngles = newRotation;
        myAnimator.SetFloat("Forward", 1, 0.1f, Time.deltaTime);
    }

    public void OnRespawn()
	{
        liveHealth = myPlayerModule.characterParameters.health;
	}

    public void DealDamages ( DamagesInfos _damagesToDeal )
    {
        myPlayerModule.allHitTaken.Add(_damagesToDeal);
        liveHealth -= _damagesToDeal.damages.damageHealth;
    }

    public void KillPlayer ()
    {

    }
}
