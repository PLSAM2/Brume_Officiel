using DarkRift;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
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
    public TextMeshProUGUI nameText;
    public TextMeshProUGUI lifeCount;
    public Image life;

    [ReadOnly] public ushort liveHealth { get => _liveHealth; set { _liveHealth = value; if (_liveHealth <= 0) KillPlayer(); } }
    public Action<string> triggerAnim;

    private UnityClient currentClient;
    private Vector3 lastPosition;
    private Vector3 lastRotation;

    [Header("Fog")]
    public GameObject fowPrefab;
    Fow myFow;
    [SerializeField] float fowRaduis = 7;
    [SerializeField] float fowRaduisInBrume = 4;

    public List<GameObject> objToHide = new List<GameObject>();
	public static Action disableModule;

    private void Awake()
    {
        lastPosition = transform.position;
        lastRotation = transform.localEulerAngles;
        OnRespawn();
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

        if (isOwner)
        {
            GameManager.Instance.ResetCam();
           // GameManager.Instance.myCam.m_Follow = transform;
            myPlayerModule.enabled = true;

            myPlayerModule.onSendMovement += OnPlayerMove;

            circleDirection.SetActive(true);
            UiManager.Instance.myPlayerModule = myPlayerModule;

            SpawnFow();
        }
        else
        {
            if(myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
            {
                SpawnFow();
            }
        }
    }

    void SpawnFow()
    {
        myFow = Instantiate(fowPrefab, transform.position, Quaternion.identity).GetComponent<Fow>();
        myFow.Init(transform);
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
        if(myFow != null)
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
        lifeCount.text = "HP : " + liveHealth;

        if (!isOwner) { return; }

        if (Vector3.Distance(lastPosition, transform.position) > distanceRequiredBeforeSync || Vector3.Distance(lastRotation, transform.localEulerAngles) > distanceRequiredBeforeSync)
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

	private void Update ()
	{
		if(Input.GetKeyDown(KeyCode.K))
		{
			DamagesInfos _temp = new DamagesInfos();
			_temp.damageHealth = 100;
			DealDamages(_temp);
		}
	}

	private void LateUpdate()
    {
        canvas.transform.LookAt(GameManager.Instance.defaultCam.transform.position);
        canvas.transform.rotation = Quaternion.Euler(canvas.transform.rotation.eulerAngles.x + 90, canvas.transform.rotation.eulerAngles.y + 180, canvas.transform.rotation.eulerAngles.z);
    }

    public void ChangeFowRaduis(bool _value)
    {
        switch (_value)
        {
            case true:
                myFow.ChangeFowRaduis(fowRaduisInBrume);
                    break;
            case false:
                myFow.ChangeFowRaduis(fowRaduis);
                break;
        }
    }

    void OnPlayerMove(Vector3 pos)
    {
        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        myAnimator.SetFloat("Forward", forward);
        myAnimator.SetFloat("Turn", right);

        if (Vector3.Distance(lastPosition, transform.position) > distanceRequiredBeforeSync || Vector3.Distance(lastRotation, transform.localEulerAngles) > distanceRequiredBeforeSync)
        {
            networkAnimationController.Sync2DBlendTree("Forward", "Turn", forward, right, SendMode.Unreliable); // Sync animation blend tree
        }
    }


    public void SetMovePosition(Vector3 newPos, Vector3 newRotation)
    {
        transform.position = newPos;
        transform.localEulerAngles = newRotation;
    }

    public void OnRespawn()
    {
        liveHealth = myPlayerModule.characterParameters.health;

    }

    public void DealDamages(DamagesInfos _damagesToDeal)
    {
        myPlayerModule.allHitTaken.Add(_damagesToDeal);
        liveHealth -= _damagesToDeal.damageHealth;
		print("I TOok Damage once");

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

    public void KillPlayer()
    {
        if (isOwner)
        {
			disableModule.Invoke();
			InGameNetworkReceiver.Instance.KillCharacter();
            UiManager.Instance.DisplayGeneralMessage("You have been slain");

            GameManager.Instance.ResetCam();
        }
    }

    public void TriggerTheAnim(string triggerName)
    {
        myAnimator.SetTrigger(triggerName);
    }



}
