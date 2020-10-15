using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tags 
{
    // Lobby >>       
    public static readonly ushort PlayerConnected = 0;
    public static readonly ushort Ping = 2;
    public static readonly ushort SendAllRooms = 5;
    public static readonly ushort CreateRoom = 10;
    public static readonly ushort DeleteRoom = 20;
    public static readonly ushort JoinRoom = 30;
    public static readonly ushort SwapHostRoom = 35;
    public static readonly ushort PlayerJoinedRoom = 40;
    public static readonly ushort PlayerQuitRoom = 45;
    public static readonly ushort QuitRoom = 50;
    public static readonly ushort StartGame = 80;
    public static readonly ushort LobbyStartGame = 90;
    public static readonly ushort QuitGame = 100;
    public static readonly ushort ChangeName = 110;
    public static readonly ushort ChangeTeam = 120;
    public static readonly ushort SetReady = 130;
    public static readonly ushort SetCharacter = 140;
    // <<

    // InGame >>   
    public static readonly ushort StartTimer = 300;
    public static readonly ushort StopGame = 310;
    public static readonly ushort InstantiateObject = 500;
    public static readonly ushort SynchroniseObject = 510;
    public static readonly ushort DestroyObject = 515;
    public static readonly ushort Damages = 520;
    public static readonly ushort AddPoints = 550;
    public static readonly ushort SyncTrigger = 750;
    public static readonly ushort KillCharacter = 560;
    public static readonly ushort SpawnObjPlayer = 1000;
    public static readonly ushort MovePlayerTag = 1010;
    public static readonly ushort SupprObjPlayer = 1020;
    public static readonly ushort SendAnim = 1030;
    // <<
}
