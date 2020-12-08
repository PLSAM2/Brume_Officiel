
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
        Leng = 30
    }
    public enum InteractibleType : ushort
    {
        none = 0,
        Altar = 1,
        VisionTower = 2,
        Frog = 3,
        ResurectAltar = 4,
        HealthPack = 5
    }

}
