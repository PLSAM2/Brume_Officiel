using Cinemachine;
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
using static StatFactory;

public class LocalPlayer : MonoBehaviour, Damageable
{
	[TabGroup("MultiGameplayParameters")] public ushort myPlayerId;
	[TabGroup("MultiGameplayParameters")] public bool isOwner = false;
	[TabGroup("MultiGameplayParameters")] public float distanceRequiredBeforeSync = 0.1f;

	[HideInInspector] public PlayerModule myPlayerModule;

	[TabGroup("MultiGameplayParameters")] public NetworkAnimationController myAnimController;

	[Header("MultiGameplayParameters")]
	[TabGroup("MultiGameplayParameters")] public float respawnTime = 15;


	[Header("UI")]
	[TabGroup("Ui")] public UIPlayerManager myUiPlayerManager;
    [TabGroup("Ui")] public SpriteRenderer iconColorPerso;
    [TabGroup("Ui")] public Color colorMyPlayer;

    [TabGroup("MultiGameplayParameters")] private ushort _liveHealth;

	[ReadOnly]
	public ushort liveHealth
	{
		get => _liveHealth; set
		{
			_liveHealth = value;
			myUiPlayerManager.UpdateLife();
		}
	}

	[HideInInspector] public bool allCharacterSpawned = false;

	public Action<string> triggerAnim;
	public Action OnInitFinish;
	public Action<Vector3> OnPlayerDeath;

	private UnityClient currentClient;
	private Vector3 lastPosition;
	private short lastRotation = 0;

	[Header("Fog")]
	[TabGroup("Vision")] public GameObject fowPrefab;
	[HideInInspector] public Fow myFow;
	[TabGroup("Vision")] public bool forceOutline = false;

	[TabGroup("Vision")] public List<GameObject> objToHide = new List<GameObject>();
	[TabGroup("Vision")] public GameObject mesh;
	[TabGroup("Vision")] public static Action disableModule;
	[TabGroup("Vision")] public bool isVisible = false;

	//TP
	public bool forceShow = false;
	public bool isTp = false;

	//ThirdEye
	[SerializeField] GameObject waypointEnemyPrefab;

	[TabGroup("Vision")] public QuickOutline myOutline;

	public GameObject deathFx;
	public GameObject waypointAlliePrefab;
	AllieWaypoint myWaypoint;

	public AudioClip deathPerso, deathGlobal;

	public ParticleSystem addLife_blue_fx, addLife_red_fx;

	private void Awake ()
	{
		lastPosition = transform.position;
	}

	public void Init ( UnityClient newClient, bool respawned = false )
	{
		currentClient = newClient;
		myPlayerModule.teamIndex = RoomManager.Instance.actualRoom.playerList[myPlayerId].playerTeam;

			myOutline.SetColor(GameFactory.GetRelativeColor(myPlayerModule.teamIndex));


		if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
		{
			CameraManager.Instance.AddCameraSpecToPlayers(myPlayerId, this);

		}

		if (isOwner)
		{
			GameManager.Instance.ResetCam();
			myPlayerModule.enabled = true;

			SpawnFow();

			CameraManager.Instance.SetParent(transform);

			AudioManager.Instance.OnAudioPlay += OnAudioPlay;

			//	myFow.myFieldOfView.EnemySeen += myPlayerModule.WaitForHeal;

			UiManager.Instance.feedbackDeath.SetActive(false);

            iconColorPerso.color = colorMyPlayer;
        }
		else
		{
            SpawnFow();

            if (myPlayerModule.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
			{
				myWaypoint = Instantiate(waypointAlliePrefab, UiManager.Instance.parentWaypoint).GetComponent<AllieWaypoint>();
				myWaypoint.target = transform;
				myWaypoint.Init(RoomManager.Instance.GetPlayerData(myPlayerId).playerCharacter);
			}
			else
			{
                myFow.gameObject.SetActive(false);

                foreach (GameObject obj in objToHide)
				{
					obj.SetActive(false);
				}
			}
		}

		foreach (Altar alt in GameManager.Instance.allAltar)
		{
			if (alt.state == State.Captured && IsInMyTeam(alt.capturingTeam))
			{
				myPlayerModule.bonusHp++;

			}
		}

		liveHealth = (ushort)(myPlayerModule.characterParameters.maxHealth + myPlayerModule.bonusHp);

        //OnRespawn(respawned);

        OnInitFinish?.Invoke();
	}

	private void Update ()
	{
		Debug();


		if (!isOwner) { return; }

		if (Vector3.Distance(lastPosition, transform.position) > 0.1f)
		{
			lastPosition = transform.position;

			using (DarkRiftWriter _writer = DarkRiftWriter.Create())
			{
				_writer.Write(transform.position.x);
				_writer.Write(transform.position.z);

				using (Message _message = Message.Create(Tags.MovePlayerTag, _writer))
				{
					currentClient.SendMessage(_message, SendMode.Unreliable);
				}
			}
		}

		if (Mathf.Abs(transform.eulerAngles.y - lastRotation) > 15f)
		{
			SendRotation();
		}
	}

	public void SendRotation ()
	{
		lastRotation = (short)Mathf.RoundToInt(transform.eulerAngles.y);

		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(lastRotation);

			using (Message _message = Message.Create(Tags.RotaPlayer, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Unreliable);
			}
		}
	}

	void Debug ()
	{
		if (Input.GetKeyDown(KeyCode.K) && isOwner && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
		{
			DamagesInfos _temp = new DamagesInfos();
			_temp.damageHealth = 1;
			DealDamages(_temp, transform, null, true, true);
		}


		if (Input.GetKeyDown(KeyCode.O) && isOwner && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
		{
			AddHitPoint(1);
		}

		if (Input.GetKeyDown(KeyCode.P) && isOwner && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
		{
			transform.position = (GameManager.Instance.GetSpawnsOfTeam(GameFactory.GetOtherTeam(RoomManager.Instance.actualRoom.playerList[myPlayerId].playerTeam)))[0].transform.position;
		}

		if (Input.GetKeyDown(KeyCode.L) && isOwner)
		{
			addLife_blue_fx.Play();
		}
	}

	internal void AllCharacterSpawn ()
	{

		/*    ushort? wxRefId = GameFactory.GetPlayerCharacterInTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam, GameData.Character.WuXin);

        if (wxRefId != null && NetworkManager.Instance.GetLocalPlayer().ID != (ushort)wxRefId)
          {
              myUiPlayerManager.wxRef = GameManager.Instance.networkPlayers[(ushort)wxRefId];
    }*/

		allCharacterSpawned = true;

        UiManager.Instance.ActualiseLife(RoomManager.Instance.GetPlayerData(myPlayerId).playerCharacter);
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

	public float GetFowRaduis ()
	{
		return myFow.fowRaduis;
	}

	private void OnDestroy ()
	{

		if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
		{
			if (CameraManager.Instance.specCams.ContainsKey(myPlayerId))
			{
				CameraManager.Instance.specCams.Remove(myPlayerId);
			}
		}


		if (myFow != null)
		{
			Destroy(myFow.gameObject);
		}

		if (isOwner)
		{
			if (myPlayerModule.isInBrume)
			{
				GameFactory.GetBrumeById(myPlayerModule.brumeId).ForceExit(myPlayerModule);
			}
		}

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam != Team.spectator)
        {
			if (!IsInMyTeam(GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex))
				GameManager.Instance.allEnemies.Remove(this);
		}

	}

	private void OnDisable ()
	{
		if (myWaypoint != null)
		{
			Destroy(myWaypoint.gameObject);
		}


		if (!isOwner)
			return;

		AudioManager.Instance.OnAudioPlay -= OnAudioPlay;
		//	myFow.myFieldOfView.EnemySeen -= myPlayerModule.WaitForHeal;

	}
	public void SendState ( En_CharacterState _state )
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(RoomManager.Instance.actualRoom.ID);

			_writer.Write((int)_state);

			using (Message _message = Message.Create(Tags.StateUpdate, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Unreliable);
			}
		}
	}

	public void SendStatus ( Sc_Status _statusIncured )
	{
		int _indexOfTheStatus = 0;
		List<Sc_Status> _tempList = new List<Sc_Status>();
		_tempList = NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame;

		for (int i = 0; i < _tempList.Count; i++)
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


	public void OnRespawn ( bool respawned = false )
	{
		if (respawned)
		{
			if (IsInMyTeam(GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex))
			{
				liveHealth = (ushort)(myPlayerModule.characterParameters.maxHealth + GameManager.Instance.numberOfAltarControled);
			}
			else
			{
				liveHealth = (ushort)(myPlayerModule.characterParameters.maxHealth + GameManager.Instance.numberOfAltarControledByEnemy);
			}
		}
	}

	/// <summary>
	/// Deal damage to this character
	/// </summary>
	/// <param name="ignoreTickStatus"> Must have ignoreStatusAndEffect false to work</param>
	public void DealDamages ( DamagesInfos _damagesToDeal, Transform _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1 )
	{
		if (InGameNetworkReceiver.Instance.GetEndGame())
		{
			return;
		}


		ushort _finalDamage = _damagesToDeal.damageHealth;


		if (dealerID == null)
		{
			DealDamagesLocaly(_finalDamage, NetworkManager.Instance.GetLocalPlayer().ID);
		}
		else
		{
			DealDamagesLocaly(_finalDamage, (ushort)dealerID);
		}

		myPlayerModule.allHitTaken.Add(_damagesToDeal);

		AudioManager.Instance.PlayHitAudio();

		/* if ((myPlayerModule.state & _damagesToDeal.stateNeeded) != 0)
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
		 }*/

		if (_damagesToDeal.damageHealth > 0)
		{
			using (DarkRiftWriter _writer = DarkRiftWriter.Create())
			{
				_writer.Write(myPlayerId);
				_writer.Write(_finalDamage);
				using (Message _message = Message.Create(Tags.Damages, _writer))
				{
					currentClient.SendMessage(_message, SendMode.Reliable);
				}
			}

			StatFactory.AddIntStat(NetworkManager.Instance.GetLocalPlayer().playerCharacter, statType.Damage, (int)_damagesToDeal.damageHealth);
		}

		if (!ignoreStatusAndEffect)
		{
			if (_damagesToDeal.movementToApply != null)
			{
				if (_damagesToDeal.movementToApply.useForwardOfDealer)
					SendForcedMovement(_damagesToDeal.movementToApply.MovementToApply(transform.position, _positionOfTheDealer.position, _percentageOfTheMovement, _positionOfTheDealer.forward.x, _positionOfTheDealer.forward.z));
				else
					SendForcedMovement(_damagesToDeal.movementToApply.MovementToApply(transform.position, _positionOfTheDealer.position, _percentageOfTheMovement));
			}

			if (_damagesToDeal.statusToApply.Length > 0)
			{
				for (int i = 0; i < _damagesToDeal.statusToApply.Length; i++)
				{
					SendStatus(_damagesToDeal.statusToApply[i]);
				}
			}
		}
	}


	public void DealDamagesLocaly ( ushort damages, ushort dealerID, ushort? serverLife = null )
	{
		if (InGameNetworkReceiver.Instance.GetEndGame())
		{
            return;
		}

		if (damages > 0)
			myPlayerModule.GetDamageFx();

		if (isOwner)
		{
			//myPlayerModule.WaitForHeal(); // WaitForAutoHeal
			myPlayerModule.KillEveryStun();
		}



		if (damages > 0)
		{
			LocalPoolManager.Instance.SpawnNewImpactDamageFX(
				transform.position + Vector3.up * 1,
				myPlayerModule.teamIndex
			);
		}

		if (serverLife != null)
		{
			liveHealth = (ushort)serverLife;

			if (isOwner && liveHealth <= 0)
			{
				KillPlayer(RoomManager.Instance.GetPlayerData(dealerID));
			}
		}
		else
		{
			if ((int)liveHealth - (int)damages <= 0)
			{
				if (isOwner)
				{
					KillPlayer(RoomManager.Instance.GetPlayerData(dealerID));
				}
			}
			else
			{
				int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)damages, 0, 1000);
				liveHealth = (ushort)_tempHp;
			}
		}

        GameManager.Instance.OnPlayerGetDamage?.Invoke(myPlayerId, damages, dealerID);
    }

	/// <summary>
	/// DO NOT use this until YOU KNOW what you do :)
	/// </summary>
	public void ForceDealDamages ( ushort dmg )
	{
		if ((int)liveHealth - (int)dmg <= 0)
		{
			liveHealth = 0;
		}
		else
		{
			int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)dmg, 0, 1000);
			liveHealth = (ushort)_tempHp;
		}
	}

	public void LocallyDivideHealth ( ushort divider )
	{
		liveHealth = (ushort)Mathf.Round(liveHealth / divider);
	}
	public void HealPlayer ( ushort value )
	{
		if (InGameNetworkReceiver.Instance.GetEndGame())
		{
			return;
		}


		HealLocaly(value);

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

	public void HealLocaly ( ushort value )
	{
		int _tempHp = (int)liveHealth + (int)value;
		liveHealth = (ushort)Mathf.Clamp(_tempHp, 1, myPlayerModule.characterParameters.maxHealth + myPlayerModule.bonusHp);

		GameManager.Instance.OnPlayerGetHealed?.Invoke(myPlayerId, value);
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

	public void SendSpawnAOEFx ( Vector3 _pos, float _scale, float _time )
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(_pos.x);
			_writer.Write(_pos.z);

			_writer.Write(_scale);

			_writer.Write(_time);

			using (Message _message = Message.Create(Tags.SpawnAOEFx, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	public void SendEnemySpot ( ushort _id )
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(_id);

			using (Message _message = Message.Create(Tags.SpotPlayer, _writer))
			{
				currentClient.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	[SerializeField] float timeSpotDisplay = 2;


	internal void KillPlayerLocaly ()
	{

		if (deathFx != null)
		{
			FowDeath fow = Instantiate(deathFx, transform.position, transform.rotation).GetComponent<FowDeath>();
			if (isOwner)
			{
				fow.fowDeath.gameObject.SetActive(true);
				fow.fowDeath.GenerateFowStatic();
			}
		}
	}


	public void KillPlayer ( PlayerData killer )
	{
		if (isOwner)
		{
			PlayerData p = NetworkManager.Instance.GetLocalPlayer();
			if (p.playerCharacter == Character.Re || p.playerCharacter == Character.Leng)
			{
				GameManager.Instance.Revive(true);
			}


			UiManager.Instance.feedbackDeath.SetActive(true);

			//GameManager.Instance.hiddenEffect.enabled = false;
			//GameManager.Instance.surchargeEffect.enabled = false;
			myPlayerModule.ForceQuitAllInteractible();
			OnPlayerDeath?.Invoke(transform.position);
			disableModule.Invoke();
			InGameNetworkReceiver.Instance.KillCharacter(killer);
			UiManager.Instance.SetAltarCaptureUIState(false);
			UiManager.Instance.myAnnoncement.ShowAnnoncement("<color=" + GameFactory.GetColorTeamInHex(Team.blue) + ">YOU HAVE BEEN SLAIN </color>");

			GameManager.Instance.ResetCam();

			if (deathPerso != null)
			{
				AudioManager.Instance.Play2DAudio(deathPerso);
			}
		}
		else
		{
			if (deathGlobal != null)
			{
				AudioManager.Instance.Play2DAudio(deathGlobal);
			}
		}
	}

	/// <summary>
	/// Synchronise une étape d'un sort
	/// </summary>
	/// <param name="_spellIndex"> Index du spell </param>
	/// <param name="spellStep">Etape du spell a envoyer</param>
	public void UpdateSpellStep ( En_SpellInput _spellIndex, En_SpellStep spellStep )
	{

		using (DarkRiftWriter Writer = DarkRiftWriter.Create())
		{
			Writer.Write((ushort)_spellIndex);
			Writer.Write((ushort)spellStep);

			using (Message Message = Message.Create(Tags.SpellStep, Writer))
			{
				currentClient.SendMessage(Message, SendMode.Reliable);
			}
		}
		//UpdateSpellStepInServer(_spellIndex, spellStep);
	}

	/// <summary>
	/// Recoit la synchro d'une étape d'un sort, non recu par l'envoyeur
	/// </summary>
	public void UpdateSpellStepInServer ( ushort _spellIndex, En_SpellStep _spellStep )
	{
		switch (_spellIndex)
		{
			case 1:
				myPlayerModule.leftClick.FeedbackSpellStep(_spellStep);
				break;
			case 2:
				myPlayerModule.firstSpell.FeedbackSpellStep(_spellStep);
				break;
			case 3:
				myPlayerModule.secondSpell.FeedbackSpellStep(_spellStep);
				break;
			case 5:
				myPlayerModule.wardModule.FeedbackSpellStep(_spellStep);
				break;
		}
	}

	public void OnStateReceived ( int _state )
	{

		if (!isOwner)
		{
			myPlayerModule.state = (En_CharacterState)_state;

		}
	}

	public void OnAddedStatus ( int _newStatus )
	{
		if (isNegative(_newStatus))
		{
			if ((myPlayerModule.state & En_CharacterState.Invulnerability) == 0 || (myPlayerModule.state & En_CharacterState.Intangenbility) == 0)
			{
				myPlayerModule.KillEveryStun();
				myPlayerModule.AddStatus(NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame[_newStatus].effect);
			}
		}
		else
		{
			myPlayerModule.AddStatus(NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame[_newStatus].effect);
		}
	}

	bool isNegative ( int _newStatus )
	{
		Sc_Status _statusTryingToAdd = NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame[_newStatus];

		if ((_statusTryingToAdd.effect.stateApplied & En_CharacterState.Slowed) != 0 || (_statusTryingToAdd.effect.stateApplied & En_CharacterState.Stunned) != 0)
			return true;
		else
			return false;
	}

	public void OnForcedMovementReceived ( ForcedMovement _movementSent )
	{
		myPlayerModule.KillEveryStun();
		if ((myPlayerModule.state & En_CharacterState.Invulnerability) == 0)
			myPlayerModule.movementPart.AddDash(_movementSent);
		else
			myPlayerModule.hitCountered?.Invoke();
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
	private void OnAudioPlay ( Vector3 obj, Team audioTeam )
	{
		  if (this.transform.position == obj || isOwner == false)
		   {
			   return;
		   }
		   GameObject _newPointer = myUiPlayerManager.GetFirstDisabledPointer();

		   _newPointer.GetComponent<CompassPointer>().InitNewTargetOneTime(this.transform, obj, audioTeam);
	}

	IEnumerator TimerShowPlayer ( float _time )
	{
		forceOutline = true;
		yield return new WaitForSeconds(_time);
		forceOutline = false;
	}

	public bool IsInMyTeam ( Team _indexTested )
	{
		return myPlayerModule.teamIndex == _indexTested;
	}

	Waypoint waypointThirdEye;
	public void MarkThirdEye ( bool _activate )
	{
		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myPlayerModule.teamIndex))
		{
			// LES YEUx
			// myUiPlayerManager.Eye_Spot.SetActive(_activate);
		}
		else
		{
            if (_activate)
            {
                waypointThirdEye = Instantiate(waypointEnemyPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
                waypointThirdEye.targetVector = transform.position;
                waypointThirdEye.SetImageColor(GameFactory.GetColorTeam(Team.red));
            }
            else
            {
                if (waypointThirdEye)
                {
                    Destroy(waypointThirdEye.gameObject);
                }
            }
            forceOutline = _activate;
		}

	}

	public void AddHitPoint ( int _int )
	{
		myPlayerModule.bonusHp += _int;
		liveHealth += (ushort)_int;
		myUiPlayerManager.AddLifePoint(_int);

		if (myPlayerModule.teamIndex == GameFactory.GetActualPlayerFollow().myPlayerModule.teamIndex)
		{
			UiManager.Instance.ActualiseLife(RoomManager.Instance.GetPlayerData(myPlayerId).playerCharacter);
			PlayFxLifeGain(true);
		}
		else
			PlayFxLifeGain(true);
	}

	public void PlayFxLifeGain ( bool inMyTeam )
	{
		if (inMyTeam)
		{
			addLife_blue_fx.Play();
		}
		else
		{
			addLife_red_fx.Play();
		}
	}
}

public interface Damageable
{
	void DealDamages ( DamagesInfos _damagesToDeal, Transform _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1 );

	bool IsInMyTeam ( Team _indexTested );
}
