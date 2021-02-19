
using UnityEngine;

public class GameData
{
    public static ushort ultiMaxWX = 7;
    public static ushort ultiMaxRE = 5;
    public static ushort ultiMaxLENG = 6;

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
	public enum InteractibleType : ushort
    {
        none = 0,
        Altar = 1,
        VisionTower = 2,
        Frog = 3,
        ResurectAltar = 4,
        HealthPack = 5,
        UltPickup = 6
    }
    public enum En_SpellStep : ushort
    {
        Canalisation = 0,
        Annonciation = 1,
        Resolution = 2,
        Interrupt = 3
    }
}
