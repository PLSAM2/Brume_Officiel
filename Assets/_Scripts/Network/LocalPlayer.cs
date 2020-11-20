using DarkRift;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class LocalPlayer : MonoBehaviour
{
    public ushort myPlayerId;
    public bool isOwner = false;
    public float distanceRequiredBeforeSync = 0.1f;

    public PlayerModule myPlayerModule;

    public Animator myAnimator;
    [SerializeField] NetworkAnimationController networkAnimationController;
    [SerializeField] GameObject circleDirection;

    [Header("MultiGameplayParameters")]
    public float respawnTime = 15;
    private ushort _liveHealth;

    [Header("UI")]
    public GameObject canvas;
    public Quaternion canvasRot;
    public TextMeshProUGUI nameText;
    public TextMeshProUGUI lifeCount;
    public Image life;

    [ReadOnly]
    public ushort liveHealth
    {
        get => _liveHealth; set
        {
            _liveHealth = value;
            lifeCount.text = "HP : " + liveHealth;
            if (liveHealth <= 0)
            {
                KillPlayer();
            }
        }
    }
    public Action<string> triggerAnim;

    private UnityClient currentClient;
    private Vector3 lastPosition;
    private Vector3 lastRotation;

    [Header("Fog")]
    public GameObject fowPrefab;
    Fow myFow;
    public bool forceShow = false;

    public List<GameObject> objToHide = new List<GameObject>();
    public static Action disableModule;
    public bool isVisible = false;

    public QuickOutline myOutline;

    [Header("Audio")]
    [SerializeField] GameObject prefabAudioPlayer;



    private void Awake()
    {
        lastPosition = transform.position;
        lastRotation = transform.localEulerAngles;
        OnRespawn();

        canvasRot = canvas.transform.rotation;
    }

    private void Start()
    {
        triggerAnim += TriggerTheAnim;

        nameText.text = RoomManager.Instance.actualRoom.playerList[myPlayerId].Name;

        if (myPlayerModule.teamIndex == Team.blue)
        {
            nameText.color = Color.blue;
            life.color = Color.blue;
        }
        else if (myPlayerModule.teamIndex == Team.red)
        {
            nameText.color = Color.red;
            life.color = Color.red;
        }

        OnPlayerMove(Vector3.zero);
    }

    public void Init(UnityClient newClient)
    {
        currentClient = newClient;
        myPlayerModule.teamIndex = RoomManager.Instance.actualRoom.playerList[myPlayerId].playerTeam;

        myOutline.SetColor(GameFactory.GetColorTeam(myPlayerModule.teamIndex));

        if (isOwner)
        {
            GameManager.Instance.ResetCam();
            myPlayerModule.enabled = true;

            myPlayerModule.onSendMovement += OnPlayerMove;

            circleDirection.SetActive(true);
            SpawnFow();

            CameraManager.Instance.SetParent(transform);
        }
        else
        {
            if (myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
            {
                SpawnFow();
            }
            else
            {
                foreach (GameObject obj in objToHide)
                {
                    obj.SetActive(false);
                }
            }
            oldPos = transform.position;
        }
    }

    Vector3 oldPos;
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.K) && isOwner)
        {
            DamagesInfos _temp = new DamagesInfos();
            _temp.damageHealth = 100;
            DealDamages(_temp);
        }

        //  transform.position = new Vector3(transform.position.x, 0, transform.position.z);

        if (!isOwner)
        {
            float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
            float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;

            velocityX = Mathf.Clamp(velocityX, -1, 1);
            velocityZ = Mathf.Clamp(velocityZ, -1, 1);

            Vector3 pos = new Vector3(velocityX, 0, velocityZ);

            float right = Vector3.Dot(transform.right, pos);
            float forward = Vector3.Dot(transform.forward, pos);

            myAnimator.SetFloat("Forward", Mathf.Lerp(myAnimator.GetFloat("Forward"), forward, Time.deltaTime * 30));
            myAnimator.SetFloat("Turn", Mathf.Lerp(myAnimator.GetFloat("Turn"), right, Time.deltaTime * 30));

            oldPos = transform.position;
        }
    }

    private void LateUpdate()
    {
        canvas.transform.rotation = canvasRot;
    }

    void SpawnFow()
    {
        myFow = Instantiate(fowPrefab, transform.position, Quaternion.identity).GetComponent<Fow>();
        myFow.Init(transform, myPlayerModule.characterParameters.visionRange);
    }

    public void ShowHideFow(bool _value)
    {
        if (myPlayerModule.teamIndex != RoomManager.Instance.GetLocalPlayer().playerTeam)
        {
            return;
        }

        if (_value)
        {
            myFow.gameObject.SetActive(true);
            //ChangeFowRaduis(myPlayerModule.isInBrume);
        }
        else
        {
            myFow.gameObject.SetActive(false);
            //myFow.ChangeFowRaduis(0);
        }
    }



    private void OnDestroy()
    {
        if (myFow != null)
        {
            Destroy(myFow.gameObject);
        }
    }

    private void OnDisable()
    {
        if (!isOwner)
            return;

        myPlayerModule.onSendMovement -= OnPlayerMove;
        triggerAnim -= TriggerTheAnim;
    }

    void FixedUpdate()
    {
        if (!isOwner) { return; }

        if (lastPosition != transform.position || lastRotation != transform.localEulerAngles)
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

    public void SendState(En_CharacterState _state)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            _writer.Write((ushort)_state);

            using (Message _message = Message.Create(Tags.StateUpdate, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Unreliable);
            }
        }
    }

    public void SendStatus(Sc_Status _statusIncured)
    {
        ushort _indexOfTheStatus = 0;
        List<Sc_Status> _tempList = new List<Sc_Status>();
        _tempList = NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame;

        for (ushort i = 0; i < _tempList.Count; i++)
        {
            if (_tempList[i] == _statusIncured)
            {
                _indexOfTheStatus = i;
                break;
            }
            if (i == _tempList.Count - 1)
                return;
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            _writer.Write(_indexOfTheStatus);

            _writer.Write(myPlayerId);

            using (Message _message = Message.Create(Tags.AddStatus, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    public void SendForcedMovement(ForcedMovement _movement)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.actualRoom.ID);

            _writer.Write((sbyte)(Mathf.RoundToInt(_movement.direction.x * 10)));
            _writer.Write((sbyte)(Mathf.RoundToInt(_movement.direction.z * 10)));
            _writer.Write((ushort)(Mathf.RoundToInt(_movement.duration * 100)));
            _writer.Write((ushort)(Mathf.RoundToInt(_movement.strength * 100)));
            _writer.Write(myPlayerId);

            using (Message _message = Message.Create(Tags.AddForcedMovement, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Unreliable);
            }
        }
    }

    public void ChangeFowRaduis(bool _value)
    {
        if (myFow == null) { return; }

        switch (_value)
        {
            case true:
                myFow.ChangeFowRaduis(myPlayerModule.characterParameters.visionRangeInBrume);
                break;
            case false:
                myFow.ChangeFowRaduis(myPlayerModule.characterParameters.visionRange);
                break;
        }
    }

    void OnPlayerMove(Vector3 pos)
    {
        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        if (myAnimator.GetFloat("Forward") != forward || myAnimator.GetFloat("Turn") != right)
        {
            myAnimator.SetFloat("Forward", forward);
            myAnimator.SetFloat("Turn", right);

            //networkAnimationController.Sync2DBlendTree(forward, right, SendMode.Unreliable);
        }
    }

    public void SetMovePosition(Vector3 newPos, Vector3 newRotation)
    {
        transform.position = newPos;
        transform.localEulerAngles = newRotation;
    }

    public void OnRespawn()
    {
        liveHealth = myPlayerModule.characterParameters.maxHealth;
    }

    public void DealDamages(DamagesInfos _damagesToDeal, PlayerData killer = null)
    {
        myPlayerModule.allHitTaken.Add(_damagesToDeal);
        int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)_damagesToDeal.damageHealth, 0, 1000);
        liveHealth = (ushort)_tempHp;


        if (GameManager.Instance.GetLocalPlayerObj().myPlayerModule.isPoisonousEffectActive)
        {
            SendStatus(myPlayerModule.poisonousEffect);
        }

        foreach (Sc_Status statusToApply in _damagesToDeal.statusToApply)
        {
            SendStatus(statusToApply);
        }

        if (_damagesToDeal.damageHealth > 0)
        {
            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(myPlayerId);
                _writer.Write(_damagesToDeal.damageHealth);
                using (Message _message = Message.Create(Tags.Damages, _writer))
                {
                    currentClient.SendMessage(_message, SendMode.Reliable);
                }
            }
        }

    }

    public void HealPlayer(ushort value)
    {
        int _tempHp = (int)Mathf.Clamp((int)liveHealth + (int)value, 0, 1000);
        liveHealth = (ushort)_tempHp;

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(myPlayerId);
            _writer.Write(value);

            using (Message _message = Message.Create(Tags.Heal, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Reliable);
            }
        }
    }


    public void KillPlayer(PlayerData killer = null)
    {
        if (isOwner)
        {
            disableModule.Invoke();
            InGameNetworkReceiver.Instance.KillCharacter(killer);
            UiManager.Instance.DisplayGeneralMessage("You have been slain");

            GameManager.Instance.ResetCam();
        }
    }

    public void OnStateReceived(ushort _state)
    {
        myPlayerModule.state = (En_CharacterState)_state;
    }

    public void OnAddedStatus(ushort _newStatus)
    {
        myPlayerModule.AddStatus(NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame[(int)_newStatus].effect);
    }
    public void OnForcedMovementReceived(ForcedMovement _movementSent)
    {
        myPlayerModule.movementPart.AddDash(_movementSent);
    }

    public void TriggerTheAnim(string triggerName)
    {
        myAnimator.SetTrigger(triggerName);
    }

    public void BoolTheAnim(string _triggerName, bool _value)
    {
        myAnimator.SetBool(_triggerName, _value);
    }

    Coroutine timerShow;
    public void ForceShowPlayer(float _time)
    {
        if (timerShow != null)
        {
            StopCoroutine(timerShow);
        }

        StartCoroutine(TimerShowPlayer(_time));
    }

    IEnumerator TimerShowPlayer(float _time)
    {
        forceShow = true;
        yield return new WaitForSeconds(_time);
        forceShow = false;
    }
}
