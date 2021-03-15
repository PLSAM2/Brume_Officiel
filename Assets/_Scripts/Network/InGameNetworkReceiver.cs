﻿using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class InGameNetworkReceiver : MonoBehaviour
{
	private static InGameNetworkReceiver _instance;
	public static InGameNetworkReceiver Instance { get { return _instance; } }

	// int numberOfPlayerToSpawn;
	// <<

	private bool isWaitingForRespawn = false;
	UnityClient client;

	private bool isEndGame = false;

	private void Awake ()
	{
		if (_instance != null && _instance != this)
		{
			Destroy(this.gameObject);
		}
		else
		{
			_instance = this;
		}

		client = RoomManager.Instance.client;
		client.MessageReceived += OnMessageReceive;
	}


	private void OnDisable ()
	{
		client.MessageReceived -= OnMessageReceive;
	}
	private void Start ()
	{
		SendSpawnChamp();

		//  numberOfPlayerToSpawn = RoomManager.Instance.actualRoom.playerList.Count;
	}
	private void OnMessageReceive ( object sender, MessageReceivedEventArgs e )
	{

		using (Message message = e.GetMessage() as Message)
		{
			if (message.Tag == Tags.MovePlayerTag)
			{
				SendPlayerMove(sender, e);
			}
			else if (message.Tag == Tags.SupprObjPlayer)
			{
				SupprPlayerInServer(sender, e);
			}
			else if (message.Tag == Tags.KillCharacter)
			{
				KillCharacterInServer(sender, e);
			}
			else if (message.Tag == Tags.Damages)
			{
				TakeDamagesInServer(sender, e);
			}
			else if (message.Tag == Tags.Heal)
			{
				HealInServer(sender, e);
			}
			else if (message.Tag == Tags.LaunchWard)
			{
				LaunchWardInServer(sender, e);
			}
			else if (message.Tag == Tags.StartWardLifeTime)
			{
				StartWardLifeTimeInServer(sender, e);
			}
			else if (message.Tag == Tags.CurveSpellLaunch)
			{
				CurveSpellLaunchInServer(sender, e);
			}
			else if (message.Tag == Tags.CurveSpellLanded)
			{
				CurveSpellLandedInServer(sender, e);
			}
			else if (message.Tag == Tags.StateUpdate)
			{
				ReceiveState(sender, e);
			}
			else if (message.Tag == Tags.AddForcedMovement)
			{
				ForcedMovementReceived(sender, e);
			}
			else if (message.Tag == Tags.AddStatus)
			{
				ReceiveStatusToAdd(sender, e);
			}
			else if (message.Tag == Tags.AltarTrailDebuff)
			{
				AltarTrailDebuffInServer(sender, e);
			}
			else if (message.Tag == Tags.AltarSpeedBuff)
			{
				AltarSpeedBuffInServer(sender, e);
			}
			else if (message.Tag == Tags.AltarPoisonBuff)
			{
				AltarBuffPoison(sender, e);
			}
			else if (message.Tag == Tags.AltarOutlineBuff)
			{
				AltarOutlineBuff(sender, e);
			}
			else if (message.Tag == Tags.ChangeFowSize)
			{
				ChangeFowSize(sender, e);
			}
			else if (message.Tag == Tags.ForceFowSize)
			{
				ForceFowSize(sender, e);
			}
			else if (message.Tag == Tags.SpawnGenericFx)
			{
				OnSpawnGenericFx(sender, e);
			}
			else if (message.Tag == Tags.SpawnAOEFx)
			{
				OnSpawnAOEFx(sender, e);
			}
			else if (message.Tag == Tags.AddUltimatePoint)
			{
				AddUltimatePoint(sender, e);
			}
			else if (message.Tag == Tags.AddUltimatePointToAllTeam)
			{
				AddUltimatePointToAllTeam(sender, e);
			}
			//else if (message.Tag == Tags.BrumeSoulSpawnCall)
			//{
			//    BrumeSoulSpawnCall(sender, e);
			//}
			//else if (message.Tag == Tags.BrumeSoulPicked)
			//{
			//    BrumeSoulPicked(sender, e);
			//}
			else if (message.Tag == Tags.NewChatMessage)
			{
				NewChatMessage(sender, e);
			}
			else if (message.Tag == Tags.SpellStep)
			{
				SpellStep(sender, e);
			}
			else if (message.Tag == Tags.Tp)
			{
				TpInServer(sender, e);
			}
			else if (message.Tag == Tags.DynamicWallState)
			{
				DynamicWallState(sender, e);
			}
			else if (message.Tag == Tags.SpotPlayer)
			{
				SpotPlayer(sender, e);
			}			

		}
	}

	private void SpotPlayer ( object sender, MessageReceivedEventArgs e )
	{
		StartCoroutine(GameManager.Instance.currentLocalPlayer.SpotPlayer());
	}

	private void DynamicWallState ( object sender, MessageReceivedEventArgs e )
	{
		GameManager.Instance.dynamicWalls.SetDoorState(false);
	}

	private void TpInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			Vector3 _newPos = Vector3.zero;
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();
				bool _tpState = reader.ReadBoolean();

				if (_tpState)
				{
					_newPos = new Vector3(reader.ReadSingle(), 0, reader.ReadSingle());
				}


				if (GameManager.Instance.networkPlayers.ContainsKey(_id))
				{
					GameManager.Instance.networkPlayers[_id].GetComponent<TeleportationModule>().SetTpStateInServer(_tpState, _newPos);
				}
			}
		}
	}

	private void SpellStep ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();
				ushort _spellIndex = reader.ReadUInt16();
				En_SpellStep _spellStep = (En_SpellStep)reader.ReadUInt16();

				if (GameManager.Instance.networkPlayers.ContainsKey(_id))
				{
					GameManager.Instance.networkPlayers[_id].UpdateSpellStepInServer(_spellIndex, _spellStep);
				}
			}
		}
	}

	private void NewChatMessage ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();
				string _message = reader.ReadString();
				bool fromServer = reader.ReadBoolean();

				UiManager.Instance.chat.ReceiveNewMessage(_message, _id, fromServer);
			}
		}

	}

	private void OnSpawnGenericFx ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _idFx = reader.ReadUInt16();

				float _posX = reader.ReadSingle();
				float _posZ = reader.ReadSingle();

				float _rota = reader.ReadSingle();
				float _scale = reader.ReadSingle();

				float _time = reader.ReadSingle();

				LocalPoolManager.Instance.SpawnNewGenericInLocal(_idFx, new Vector3(_posX, 0, _posZ), _rota, _scale, _time);
			}
		}
	}

	private void OnSpawnAOEFx ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
                ushort _idPlayer = reader.ReadUInt16();

				float _posX = reader.ReadSingle();
				float _posZ = reader.ReadSingle();

				float _scale = reader.ReadSingle();

				float _time = reader.ReadSingle();

				LocalPoolManager.Instance.SpawnNewAOELocal(_idPlayer, new Vector3(_posX, 0, _posZ), _scale, _time);
			}
		}
	}

	private void LaunchWardInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();

				float xDestination = reader.ReadSingle();
				float yDestination = reader.ReadSingle();
				float zDestination = reader.ReadSingle();
				Vector3 destination = new Vector3(xDestination, yDestination, zDestination);

				GameManager.Instance.networkPlayers[_id].GetComponent<WardModule>().InitWardLaunch(destination);
			}
		}
	}

	private void StartWardLifeTimeInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();

				GameManager.Instance.networkPlayers[_id].GetComponent<WardModule>().WardLanded();
			}
		}
	}


	private void CurveSpellLaunchInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();

				float xDestination = reader.ReadSingle();
				float yDestination = reader.ReadSingle();
				float zDestination = reader.ReadSingle();
				Vector3 destination = new Vector3(xDestination, yDestination, zDestination);

				GameManager.Instance.networkPlayers[_id].GetComponent<Module_Spit>().InitLaunch(destination);
			}
		}
	}

	private void CurveSpellLandedInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();

				GameManager.Instance.networkPlayers[_id].GetComponent<Module_Spit>().Landed();
			}
		}
	}




	void SendSpawnChamp ()
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			_writer.Write(RoomManager.Instance.actualRoom.ID);
			_writer.Write(client.ID);

			using (Message _message = Message.Create(Tags.SpawnObjPlayer, _writer))
			{
				client.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	public void KillCharacter ( PlayerData killer = null )
	{
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			if (killer != null)
			{
				_writer.Write(killer.ID);
			}
			else
			{
				_writer.Write(NetworkManager.Instance.GetLocalPlayer().ID);
			}

			_writer.Write((ushort)NetworkManager.Instance.GetLocalPlayer().playerCharacter);
			using (Message _message = Message.Create(Tags.KillCharacter, _writer))
			{
				client.SendMessage(_message, SendMode.Reliable);
			}
		}
	}

	private void KillCharacterInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort id = reader.ReadUInt16();
				ushort killerId = reader.ReadUInt16();

				SupprPlayer(id);

				GameManager.Instance.OnPlayerDie?.Invoke(id, killerId);

			}
		}
	}

	private void TakeDamagesInServer ( object sender, MessageReceivedEventArgs e )
	{
		if (isEndGame)
		{
			return;
		}
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();
				ushort _damages = reader.ReadUInt16();
				ushort _dealer = reader.ReadUInt16();

				if (!GameManager.Instance.networkPlayers.ContainsKey(_id))
				{
					return;
				}

				LocalPlayer target = GameManager.Instance.networkPlayers[_id];
				target.DealDamagesLocaly(_damages, _dealer);
			}
		}
	}

	private void HealInServer ( object sender, MessageReceivedEventArgs e )
	{
		if (isEndGame)
		{
			return;
		}

		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _id = reader.ReadUInt16();
				ushort _healValue = reader.ReadUInt16();

				if (!GameManager.Instance.networkPlayers.ContainsKey(_id))
				{
					return;
				}

				LocalPlayer target = GameManager.Instance.networkPlayers[_id];
				target.HealLocaly(_healValue);
			}
		}
	}

	void SupprPlayerInServer ( object _sender, MessageReceivedEventArgs _e )
	{
		using (Message message = _e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort id = reader.ReadUInt16();
				SupprPlayer(id);
			}
		}
	}

	public void SupprPlayer ( ushort ID )
	{
		if (GameManager.Instance.networkPlayers.ContainsKey(ID))
		{
			Destroy(GameManager.Instance.networkPlayers[ID].gameObject);
			GameManager.Instance.networkPlayers.Remove(ID);
		}
	}



	void SendPlayerMove ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				if (message.Tag == Tags.MovePlayerTag)
				{
					ushort id = reader.ReadUInt16();

					if (!GameManager.Instance.networkPlayers.ContainsKey(id))
					{
						return;
					}

					GameManager.Instance.networkPlayers[id].myAnimController.SetMovePosition(

						new Vector3( //Position
						reader.ReadSingle(),
						GameManager.Instance.networkPlayers[id].transform.position.y,
						reader.ReadSingle()),

						new Vector3( //Rotation
						0,
						reader.ReadSingle(),
						0)
				   );
				}
			}
		}
	}

	public void ReceiveState ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				if (message.Tag == Tags.StateUpdate)
				{
					ushort id = reader.ReadUInt16();

					if (!GameManager.Instance.networkPlayers.ContainsKey(id))
					{
						return;
					}
					GameManager.Instance.networkPlayers[id].OnStateReceived(reader.ReadUInt16());
				}
			}
		}
	}

	private void ForcedMovementReceived ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage() as Message)
		{
			using (DarkRiftReader reader = message.GetReader())
			{

				sbyte _newX = reader.ReadSByte();
				sbyte _newZ = reader.ReadSByte();
				ushort _newDuration = reader.ReadUInt16();
				ushort _newStrength = reader.ReadUInt16();
				ushort id = reader.ReadUInt16();

				float _directionX = (float)_newX / 10;
				float _directionZ = (float)_newZ / 10;
				float _duration = (float)_newDuration / 100;
				float _strength = (float)_newStrength / 100;

				ForcedMovement _newForcedMovement = new ForcedMovement();
				_newForcedMovement.direction = new Vector3(_directionX, 0, _directionZ);
				_newForcedMovement.duration = _duration;
				_newForcedMovement.strength = _strength;

				GameManager.Instance.currentLocalPlayer.myPlayerModule.KillEveryStun();
				GameManager.Instance.currentLocalPlayer.OnForcedMovementReceived(_newForcedMovement);
			}

		}
	}

	public void ReceiveStatusToAdd ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _roomId = reader.ReadUInt16();
				ushort _statusId = reader.ReadUInt16();
				ushort _playerId = reader.ReadUInt16();

				if (!GameManager.Instance.networkPlayers.ContainsKey(_playerId)) { return; }

				if (NetworkObjectsManager.Instance.networkedObjectsList.allStatusOfTheGame[(int)_statusId].effect.isHardControl)
					GameManager.Instance.networkPlayers[_playerId].myPlayerModule.KillEveryStun();

				GameManager.Instance.networkPlayers[_playerId].OnAddedStatus(_statusId);
			}
		}
	}

	private void AltarTrailDebuffInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _ID = reader.ReadUInt16();

				WxController _temp = (WxController)GameManager.Instance.networkPlayers[_ID].myPlayerModule;
				_temp.ApplyAltarTrailDebuffInServer();
			}

		}
	}


	private void AltarSpeedBuffInServer ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				PlayerModule _temp = GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule;
				_temp.ApplySpeedBuffInServer();
			}
		}
	}

	private void AltarBuffPoison ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				PlayerModule _temp = GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule;
				_temp.ApplyPoisonousBuffInServer();
			}
		}
	}

	private void AltarOutlineBuff ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _ID = reader.ReadUInt16();

				WxController _temp = (WxController)GameManager.Instance.networkPlayers[_ID].myPlayerModule;
				_temp.ApplyOutlineDebuffInServer();
			}
		}
	}

	private void ChangeFowSize ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _playerId = reader.ReadUInt16();
				uint _size = reader.ReadUInt32();

				if (!GameManager.Instance.networkPlayers.ContainsKey(_playerId)) { return; }

				GameManager.Instance.networkPlayers[_playerId].SetFowRaduisLocal((float)_size / 100);
			}
		}
	}

	private void ForceFowSize ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _playerId = reader.ReadUInt16();
				uint _size = reader.ReadUInt32();

				if (!GameManager.Instance.networkPlayers.ContainsKey(_playerId)) { return; }

				GameManager.Instance.networkPlayers[_playerId].ForceLocalFowRaduis((float)_size / 100);
			}
		}
	}
	private void AddUltimatePoint ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				ushort _playerId = reader.ReadUInt16();
				ushort _size = reader.ReadUInt16();

				RoomManager.Instance.TryAddUltimateStacks(_playerId, _size, true);
			}
		}
	}

	private void AddUltimatePointToAllTeam ( object sender, MessageReceivedEventArgs e )
	{
		using (Message message = e.GetMessage())
		{
			using (DarkRiftReader reader = message.GetReader())
			{
				Team _team = (Team)reader.ReadUInt16();
				ushort _value = reader.ReadUInt16();

				foreach (PlayerData p in GameFactory.GetAllPlayerInTeam(_team))
				{
					RoomManager.Instance.TryAddUltimateStacks(p.ID, _value, false);
				}
			}
		}
	}

	public void SetEndGame ( bool value = true )
	{
		isEndGame = value;
	}
	public bool GetEndGame ()
	{
		return isEndGame;
	}


	#region DEPRECATED

	//private void BrumeSoulSpawnCall(object sender, MessageReceivedEventArgs e)
	//{
	//    using (Message message = e.GetMessage())
	//    {
	//        using (DarkRiftReader reader = message.GetReader())
	//        {
	//            ushort _brumeId = reader.ReadUInt16();

	//            GameManager.Instance.SpawnBrumeSoul(_brumeId);
	//        }
	//    }
	//}

	//private void BrumeSoulPicked(object sender, MessageReceivedEventArgs e)
	//{
	//    using (Message message = e.GetMessage())
	//    {
	//        using (DarkRiftReader reader = message.GetReader())
	//        {
	//            ushort _brumeId = reader.ReadUInt16();

	//            GameManager.Instance.DeleteBrumeSoul(_brumeId);
	//        }
	//    }
	//}

	#endregion

}
