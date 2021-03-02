﻿
using System.Collections.Generic;
using UnityEngine;

public class GameData
{
    public enum Team : ushort
    {
        none = 0,
        red = 10,
        blue = 20
    }

    public enum Character : ushort
    {
        none = 0,
        WuXin = 10,
        Re = 20,
        Leng = 30,
		test = 40,

	}

    public static Dictionary<Character, ushort> characterUltMax = new Dictionary<Character, ushort>()
    {
        { Character.WuXin, 7 },
        { Character.Re, 5 },
        { Character.Leng, 6 }
    };

    public enum InteractibleType : ushort
    {
        none = 0,
        Altar = 1,
        VisionTower = 2,
        Frog = 3,
        ResurectAltar = 4,
        HealthPack = 5,
        UltPickup = 6,
        EndZone = 7
    }
    public enum En_SpellStep : ushort
    {
        Canalisation = 0,
        Annonciation = 1,
        Resolution = 2,
        Interrupt = 3
    }
}
