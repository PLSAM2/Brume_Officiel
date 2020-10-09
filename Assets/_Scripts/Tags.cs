using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tags 
{
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
    public static readonly ushort SpawnObjPlayer = 60;
    public static readonly ushort MovePlayerTag = 70;
    public static readonly ushort SupprObjPlayer = 80;
    public static readonly ushort StartGame = 90;
    public static readonly ushort QuitGame = 100;
    public static readonly ushort ChangeName = 110;
    public static readonly ushort ChangeTeam = 120;
    public static readonly ushort SetReady = 130;
    public static readonly ushort SetCharacter = 140;
}
