
using System.Collections.Generic;
using UnityEngine;

public class GameData
{
    public enum Team : ushort
    {
        none = 0,
        red = 10,
        blue = 20,
        spectator = 30,
        zizi = 40
    }

    public enum Character : ushort
    {
        none = 0,
        WuXin = 10,
        Re = 20,
        Leng = 30,
		test = 40,

	}

    public enum En_SoulSpell : ushort
    {
        none = 0,
        Ward = 10,
        Tp = 20,
        ThirdEye = 30,
        Invisible = 40,
        Decoy = 50,
        SpeedUp = 60,
    }

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
