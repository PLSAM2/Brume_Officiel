using DarkRift;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System;
using static GameData;

public class LocalPlayer : MonoBehaviour
{
    public ushort myPlayerId;
    public bool isOwner = false;

    public PlayerModule myPlayerModule;

    Vector3 lastPosition;

    Vector3 lastRotation;

    //
    UnityClient currentClient;

    [SerializeField] Animator myAnimator;

    [SerializeField] GameObject circleDirection;

    [Header("MultiGameplayParameters")]
    private ushort _liveHealth;
    public Team teamIndex;

    [ReadOnly] public ushort liveHealth { get => _liveHealth; set { _liveHealth = value; if (_liveHealth <= 0) KillPlayer(); } }
    public Action<string> triggerAnim;


    private void Awake()
    {
        lastPosition = transform.position;
        lastRotation = transform.localEulerAngles;
        OnRespawn();
    }

	private void Start ()
	{
        triggerAnim += TriggerTheAnim;
    }

    public void Init(UnityClient newClient)
    {
        currentClient = newClient;
        teamIndex = RoomManager.Instance.actualRoom.playerList[myPlayerId].playerTeam;


        if (isOwner)
        {
            GameManager.Instance.myCam.m_Follow = transform;
            myPlayerModule.enabled = true;

            myPlayerModule.onSendMovement += OnPlayerMove;

            circleDirection.SetActive(true);
            UiManager.instance.myPlayerModule = myPlayerModule;
        }
    }



    private void OnDisable()
    {
        if (!isOwner)
            return;

        myPlayerModule.onSendMovement -= OnPlayerMove;
        triggerAnim -= TriggerTheAnim;
    }

    void Update()
    {
        if (!isOwner) { return; }

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


    public void DealDamages (DamagesInfos _damagesToDeal)
    {
        myPlayerModule.allHitTaken.Add(_damagesToDeal);
        liveHealth -= _damagesToDeal.damages.damageHealth;

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(myPlayerId);
            _writer.Write(_damagesToDeal.damages.damageHealth);
            using (Message _message = Message.Create(Tags.Damages, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    public void KillPlayer ()
    {
        if (isOwner)
        {
            GameManager.Instance.KillCharacter();

            switch (RoomManager.Instance.GetLocalPlayer().playerTeam)
            {
                case Team.red:
                    GameManager.Instance.AddPoints(Team.blue, 5);
                    break;
                case Team.blue:
                    GameManager.Instance.AddPoints(Team.red, 5);
                    break;
                default:
                    print("Error");
                    break;
            }

        }
    }

    public void TriggerTheAnim ( string triggerName )
    {
        myAnimator.SetTrigger(triggerName);
    }
}
