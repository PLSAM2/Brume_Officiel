﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tags 
{
    /// <summary>
    /// Val 0000 --> 1000
    /// Sam 1000 --> 2000
    /// Pierre 2000 --> 3000
    /// </summary>

    // Lobby 0 --> 299 >>       
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

    // InGame 300 --> XXXX >>   
    public static readonly ushort StartTimer = 300;
    public static readonly ushort StopGame = 310;
    public static readonly ushort InstantiateObject = 500;
    public static readonly ushort SynchroniseObject = 510;
    public static readonly ushort DestroyObject = 515;
    public static readonly ushort Damages = 520;
    public static readonly ushort AddPoints = 550;
    public static readonly ushort KillCharacter = 560;

        //Anim 750 --> 800 >>
        public static readonly ushort SyncTrigger = 750;
        public static readonly ushort Sync2DBlendTree = 752;
        public static readonly ushort SyncBoolean = 754;
        public static readonly ushort SyncFloat = 756;
        // <<

    public static readonly ushort SpawnObjPlayer = 1000;
    public static readonly ushort MovePlayerTag = 1010;
    public static readonly ushort SupprObjPlayer = 1020;
    // <<
}
