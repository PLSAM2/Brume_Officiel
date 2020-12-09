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
	[TabGroup("MultiGameplayParameters")] public ushort myPlayerId;
	[TabGroup("MultiGameplayParameters")] public bool isOwner = false;
	[TabGroup("MultiGameplayParameters")] public float distanceRequiredBeforeSync = 0.1f;

	[HideInInspector] public PlayerModule myPlayerModule;

	[TabGroup("MultiGameplayParameters")] public NetworkAnimationController myAnimController;
	[TabGroup("MultiGameplayParameters")] public GameObject circleDirection;

	[Header("MultiGameplayParameters")]
	[TabGroup("MultiGameplayParameters")] public float respawnTime = 15;
	[TabGroup("MultiGameplayParameters")] private ushort _liveHealth;


	[Header("UI")]
	[TabGroup("Ui")] public GameObject canvas;
	[TabGroup("Ui")] public Quaternion canvasRot;
	[TabGroup("Ui")] public TextMeshProUGUI nameText;
	[TabGroup("Ui")] public TextMeshProUGUI lifeCount;
	[TabGroup("Ui")] public Image lifeImg;
	[TabGroup("Ui")] public Image lifeDamageImg;
	[Header("Buff")] [TabGroup("Ui")] public TextMeshProUGUI nameOfTheBuff;
	[TabGroup("Ui")] public Image fillAmountBuff;
	[TabGroup("Ui")] public GameObject wholeBuffUi;

	[TabGroup("UiState")] public GameObject statePart;
	[TabGroup("UiState")] public TextMeshProUGUI stateText;
	[TabGroup("UiState")] public Image fillPart;
	[TabGroup("UiState")] public GameObject StunIcon, HiddenIcon;
	[TabGroup("UiState")] public GameObject SlowIcon;
	[TabGroup("UiState")] public GameObject RootIcon;
	[TabGroup("UiState")] public GameObject SilencedIcon;

	Vector3 newNetorkPos;
	[HideInInspector] [SerializeField] float syncSpeed = 10;


	[ReadOnly]
	public ushort liveHealth
	{
		get => _liveHealth; set
		{
			_liveHealth = value;
			lifeCount.text = liveHealth.ToString();

			lifeImg.fillAmount = (float)liveHealth / GameFactory.GetMaxLifeOfPlayer(myPlayerId);
		}
	}
	public Action<string> triggerAnim;

	private UnityClient currentClient;
	private Vector3 lastPosition;
	private Vector3 lastRotation;

	[Header("Fog")]
	[TabGroup("Vision")] public GameObject fowPrefab;
	Fow myFow;
	[TabGroup("Vision")] public bool forceOutline = false;

	[TabGroup("Vision")] public List<GameObject> objToHide = new List<GameObject>();
	[TabGroup("Vision")] public static Action disableModule;
	[TabGroup("Vision")] public bool isVisible = false;

	[TabGroup("Vision")] public QuickOutline myOutline;
	
	public RagdollReceiver ragdoll;

	private void Awake ()
	{
		lastPosition = transform.position;
		lastRotation = transform.localEulerAngles;
		canvasRot = canvas.transform.rotation;

		newNetorkPos = transform.position;
	}

	private void Start ()
	{
		OnRespawn();

		nameText.text = RoomManager.Instance.actualRoom.playerList[myPlayerId].Name;

		if (myPlayerModule.teamIndex == Team.blue)
		{
			nameText.color = Color.blue;
			lifeImg.color = Color.blue;
		}
		else if (myPlayerModule.teamIndex == Team.red)
		{
			nameText.color = Color.red;
			lifeImg.color = Color.red;
		}
	}

	public void Init ( UnityClient newClient )
	{
		currentClient = newClient;
		myPlayerModule.teamIndex = RoomManager.Instance.actualRoom.playerList[myPlayerId].playerTeam;

		myOutline.SetColor(GameFactory.GetColorTeam(myPlayerModule.teamIndex));

		if (isOwner)
		{
			GameManager.Instance.ResetCam();
			myPlayerModule.enabled = true;

			circleDirection.SetActive(true);
			SpawnFow();

			CameraManager.Instance.SetParent(transform);
		}
		else
		{
			if (myPlayerModule.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
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
		}
	}

	private void Update ()
	{
		//ui life
		lifeDamageImg.fillAmount = Mathf.Lerp(lifeDamageImg.fillAmount, lifeImg.fillAmount, 3 * Time.deltaTime);

		Debug();

		if (!isOwner)
		{
			transform.position = Vector3.Lerp(transform.position, newNetorkPos, Time.deltaTime * syncSpeed);
		}
	}

	void Debug ()
	{
		if (Input.GetKeyDown(KeyCode.K) && isOwner)
		{
			DamagesInfos _temp = new DamagesInfos();
			_temp.damageHealth = 100;
			DealDamages(_temp, transform.position, null, true);
		}

		if (Input.GetKeyDown(KeyCode.P) && isOwner)
		{
			transform.position = (GameManager.Instance.GetSpawnsOfTeam(GameFactory.GetOtherTeam(RoomManager.Instance.actualRoom.playerList[myPlayerId].playerTeam)))[0].transform.position;
		}
	}

	private void LateUpdate ()
	{
		canvas.transform.rotation = canvasRot;
	}

	void SpawnFow ()
	{
		myFow = Instantiate(fowPrefab, transform.position, Quaternion.identity).GetComponent<Fow>();
		myFow.Init(transform, myPlayerModule.characterParameters.visionRange);
        myFow.InitPlayerModule(myPlayerModule);
    }

	public void ShowHideFow ( bool _value )
	{
		if (myPlayerModule.teamIndex != NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			return;
		}

		if (_value)
		{
			myFow.gameObject.SetActive(true);
		}
		else
		{
			myFow.gameObject.SetActive(false);
		}
	}

	public void SetFowRaduis ( float _value )
	{
		myFow.ChangeFowRaduis(_value);
	}

	public void ResetFowRaduis ()
	{
		ChangeFowRaduis(myPlayerModule.isInBrume);
	}

    private void OnDestroy()
    {
        if (myFow != null)
        {
            Destroy(myFow.gameObject);
        }

        if (isOwner)
        {
            if (myPlayerModule.isInBrume)
            {
                GameFactory.GetBrumeById(myPlayerModule.brumeId).OnSimulateExit(gameObject);
            }
        }
    }

	private void OnDisable ()
	{
		if (!isOwner)
			return;
	}

	void FixedUpdate ()
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

	public void SendState ( En_CharacterState _state )
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

	public void SendStatus ( Sc_Status _statusIncured )
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

	public void SendForcedMovement ( ForcedMovement _movement )
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

	public void ChangeFowRaduis ( bool _value )
	{
		if (myFow == null || myPlayerModule.state.HasFlag(En_CharacterState.ThirdEye))
		{
			return;
		}

		switch (_value)
		{
			case true:
				SetFowRaduis(myPlayerModule.characterParameters.visionRangeInBrume);
				break;
			case false:
				SendChangeFowRaduis(myPlayerModule.characterParameters.visionRange);
				break;
		}

        if (isOwner)
        {

        }
	}

	public void SetMovePosition ( Vector3 newPos, Vector3 newRotation )
	{
		newNetorkPos = newPos;
		transform.localEulerAngles = newRotation;
	}

	public void OnRespawn ()
	{
		liveHealth = myPlayerModule.characterParameters.maxHealth;
	}

	/// <summary>
	/// Deal damage to this character
	/// </summary>
	/// <param name="ignoreTickStatus"> Must have ignoreStatusAndEffect false to work</param>
	/// <param name="ignoreMark"> Must have ignoreStatusAndEffect false to work</param>
	public void DealDamages ( DamagesInfos _damagesToDeal, Vector3 _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false )
	{
		DealDamagesLocaly(_damagesToDeal.damageHealth, dealerID);

		myPlayerModule.allHitTaken.Add(_damagesToDeal);

		if (!ignoreStatusAndEffect)
		{
			if (!ignoreTickStatus)
			{
				if (GameFactory.GetLocalPlayerObj().myPlayerModule.isPoisonousEffectActive)
				{
					SendStatus(myPlayerModule.poisonousEffect);
				}
			}

			if (_damagesToDeal.statusToApply != null)
			{
				for (int i = 0; i < _damagesToDeal.statusToApply.Length; i++)
				{
					SendStatus(_damagesToDeal.statusToApply[i]);
				}
			}

			if (_damagesToDeal.movementToApply != null)
			{
				SendForcedMovement(_damagesToDeal.movementToApply.MovementToApply(transform.position, _positionOfTheDealer));
			}
		}


		if ((myPlayerModule.state & _damagesToDeal.stateNeeded) != 0)
		{
			if (_damagesToDeal.additionalStatusToApply != null)
			{
				for (int i = 0; i < _damagesToDeal.additionalStatusToApply.Length; i++)
				{
					SendStatus(_damagesToDeal.additionalStatusToApply[i]);
				}
			}

			if (_damagesToDeal.additionalMovementToApply != null)
			{
				SendForcedMovement(_damagesToDeal.additionalMovementToApply.MovementToApply(transform.position, _positionOfTheDealer));
			}          

			if (_damagesToDeal.damageHealth > 0)
			{
				DealDamagesLocaly(_damagesToDeal.additionalDamages, dealerID);

				using (DarkRiftWriter _writer = DarkRiftWriter.Create())
				{
					_writer.Write(myPlayerId);
					_writer.Write(_damagesToDeal.additionalDamages);
					using (Message _message = Message.Create(Tags.Damages, _writer))
					{
						currentClient.SendMessage(_message, SendMode.Reliable);
					}
				}
			}
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

			GameManager.Instance.OnPlayerGetDamage?.Invoke(myPlayerId, _damagesToDeal.damageHealth);
		}

	}

	public void DealDamagesLocaly ( ushort damages, ushort? dealerID = null )
	{
		if (isOwner)
		{
			if (((myPlayerModule.oldState & En_CharacterState.WxMarked) != 0))
			{
				print("IApplyMark");
				myPlayerModule.ApplyWxMark(dealerID);
			}
		}

		if ((int)liveHealth - (int)damages <= 0)
		{
			if (isOwner)
			{
				if (dealerID != null)
				{
					KillPlayer(RoomManager.Instance.GetPlayerData((ushort)dealerID));
				}
				else
				{
					KillPlayer();
				}
			}
		}
		else
		{
			int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)damages, 0, 1000);
			liveHealth = (ushort)_tempHp;
		}
	}

	public void HealPlayer ( ushort value )
	{
		int _tempHp = (int)Mathf.Clamp((int)liveHealth + (int)value, 0, myPlayerModule.characterParameters.maxHealth);
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

	public void SendChangeFowRaduis ( float size = 0, bool resetSize = false )
    {
        if (resetSize)
        {
            ResetFowRaduis();
        }
        else
        {
            SetFowRaduis(size);
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write((uint)size * 100);
			_writer.Write(resetSize);

			using (Message _message = Message.Create(Tags.ChangeFowSize, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	public void SendSpawnGenericFx ( ushort _index, Vector3 _pos, float _rota, float _scale, float _time )
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(_index);

			_writer.Write(_pos.x);
			_writer.Write(_pos.z);

			_writer.Write(_rota);

			_writer.Write(_scale);

			_writer.Write(_time);

			using (Message _message = Message.Create(Tags.SpawnGenericFx, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	public void SendSpawnAOEFx ( ushort _id, Vector3 _pos, float _rota, float _scale, float _time )
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(_id);

			_writer.Write(_pos.x);
			_writer.Write(_pos.z);

			_writer.Write(_rota);

			_writer.Write(_scale);

			_writer.Write(_time);

			using (Message _message = Message.Create(Tags.SpawnAOEFx, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	public void KillPlayer ( PlayerData killer = null )
	{
		if (isOwner)
		{
			disableModule.Invoke();
			InGameNetworkReceiver.Instance.KillCharacter(killer);
			UiManager.Instance.DisplayGeneralMessage("You have been slain");
			
			GameManager.Instance.ResetCam();
		}
	}

	public void OnStateReceived ( ushort _state )
	{
		if (!isOwner)
			myPlayerModule.state = (En_CharacterState)_state;
	}

	public void OnAddedStatus ( ushort _newStatus )
	{
		myPlayerModule.AddStatus(NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame[(int)_newStatus].effect);
	}
	public void OnForcedMovementReceived ( ForcedMovement _movementSent )
	{
		myPlayerModule.movementPart.AddDash(_movementSent);
	}

	Coroutine timerShow;
	public void ForceShowPlayer ( float _time )
	{
		if (timerShow != null)
		{
			StopCoroutine(timerShow);
		}

		StartCoroutine(TimerShowPlayer(_time));
	}

	//Ui character
	#region
	public void HidePseudo(bool _hidePseudo)
	{
		nameText.gameObject.SetActive(!_hidePseudo);
		statePart.SetActive(_hidePseudo);
	}

	public void ShowStateIcon ( En_CharacterState _currentState, float actualTime, float baseTime)
	{
		RootIcon.SetActive(false);
		SilencedIcon.SetActive(false);
		StunIcon.SetActive(false);
		SlowIcon.SetActive(false);
		HiddenIcon.SetActive(false);

		//	fillPart.fillAmount = actualTime / baseTime;

		if ((_currentState & En_CharacterState.Hidden) != 0)
		{
			HiddenIcon.SetActive(true);
			stateText.text = "Hidden";
			return;
		}
		else if ((_currentState & En_CharacterState.Root) != 0 && (_currentState & En_CharacterState.Silenced) != 0)
		{
			StunIcon.SetActive(true);
			stateText.text = "Stunned";
			return;

		}
		else if ((_currentState & En_CharacterState.Silenced) != 0)
		{
			SilencedIcon.SetActive(true);
			stateText.text = "Silenced";
			return;

		}
		else if ((_currentState & En_CharacterState.Root) != 0)
		{
			RootIcon.SetActive(true);
			stateText.text = "Root";
			return;

		}
		else if ((_currentState & En_CharacterState.Slowed) != 0)
		{
			SlowIcon.SetActive(true);
			stateText.text = "Slowed";
			return;

		}

	}

	public void EnableBuff(bool _stateOfBuff, string _buffName)
	{
		wholeBuffUi.SetActive(_stateOfBuff);
		nameOfTheBuff.text = _buffName;
	}

	public void UpdateBuffDuration(float _fillAmount)
	{
		fillAmountBuff.fillAmount = _fillAmount;
	}
	#endregion


	IEnumerator TimerShowPlayer ( float _time )
	{
		forceOutline = true;
		yield return new WaitForSeconds(_time);
		forceOutline = false;
	}
}
