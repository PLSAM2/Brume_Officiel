using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class StatFactory {
    // --------------------------------------- Stat --------------------------------------------------------
    public static void InitStat()
    {
        if (!PlayerPrefs.HasKey("NbrGameWX"))
        {
            PlayerPrefs.SetInt("NbrGameWX", 0);
            PlayerPrefs.SetInt("NbrGameRE", 0);
            PlayerPrefs.SetInt("NbrGameLENG", 0);
        }

        if (!PlayerPrefs.HasKey("NbrWinWX"))
        {
            PlayerPrefs.SetInt("NbrWinWX", 0);
            PlayerPrefs.SetInt("NbrWinRE", 0);
            PlayerPrefs.SetInt("NbrWinLENG", 0);
        }

        if (!PlayerPrefs.HasKey("NbrKillWX"))
        {
            PlayerPrefs.SetInt("NbrKillWX", 0);
            PlayerPrefs.SetInt("NbrKillRE", 0);
            PlayerPrefs.SetInt("NbrKillLENG", 0);
        }

        if (!PlayerPrefs.HasKey("NbrDamageWX"))
        {
            PlayerPrefs.SetInt("NbrDamageWX", 0);
            PlayerPrefs.SetInt("NbrDamageRE", 0);
            PlayerPrefs.SetInt("NbrDamageLENG", 0);
        }

        if (!PlayerPrefs.HasKey("TimePlayedWX"))
        {
            PlayerPrefs.SetInt("TimePlayedWX", 0);
            PlayerPrefs.SetInt("TimePlayedLENG", 0);
            PlayerPrefs.SetInt("TimePlayedRE", 0);
        }

        if (!PlayerPrefs.HasKey("CaptureNbr"))
        {
            PlayerPrefs.SetInt("CaptureNbr", 0);
        }
    }

    public static int GetTotalNbrGame()
    {
        return PlayerPrefs.GetInt("NbrGameWX") + PlayerPrefs.GetInt("NbrGameRE") + PlayerPrefs.GetInt("NbrGameLENG");
    }
    public static int GetTotalNbrWin()
    {
        return PlayerPrefs.GetInt("NbrWinWX") + PlayerPrefs.GetInt("NbrWinRE") + PlayerPrefs.GetInt("NbrWinLENG");
    }
    public static int GetTotalNbrKill()
    {
        return PlayerPrefs.GetInt("NbrKillWX") + PlayerPrefs.GetInt("NbrKillRE") + PlayerPrefs.GetInt("NbrKillLENG");
    }
    public static int GetTotalNbrDamage()
    {
        return PlayerPrefs.GetInt("NbrDamageWX") + PlayerPrefs.GetInt("NbrDamageRE") + PlayerPrefs.GetInt("NbrDamageLENG");
    }
    public static int GetTotalTimePlayed()
    {
        return PlayerPrefs.GetInt("TimePlayedWX") + PlayerPrefs.GetInt("TimePlayedRE") + PlayerPrefs.GetInt("TimePlayedLENG");
    }
    public static int GetCaptureNbr()
    {
        return PlayerPrefs.GetInt("CaptureNbr");
    }


    public static void AddIntStat(Character _champ, statType _stat, int _value = 0)
    {
        string champ = "WX";
        switch (_champ)
        {
            case Character.Re:
                champ = "RE";
                break;

            case Character.Leng:
                champ = "LENG";
                break;
        }

        if (_value == 0)
        {
            PlayerPrefs.SetInt(GetStringType(_stat) + champ, PlayerPrefs.GetInt(GetStringType(_stat) + champ) + 1);
        }
        else
        {
            PlayerPrefs.SetInt(GetStringType(_stat) + champ, PlayerPrefs.GetInt(GetStringType(_stat) + champ) + _value);
        }
    }

    public static int GetIntStat(Character _champ, statType _stat)
    {
        string champ = "WX";
        switch (_champ)
        {
            case Character.Re:
                champ = "RE";
                break;

            case Character.Leng:
                champ = "LENG";
                break;
        }

        return PlayerPrefs.GetInt(GetStringType(_stat) + champ);
    }

    public static void AddFloatStat(Character _champ, statType _stat)
    {
        string champ = "WX";
        switch (_champ)
        {
            case Character.Re:
                champ = "RE";
                break;

            case Character.Leng:
                champ = "LENG";
                break;
        }

        PlayerPrefs.SetFloat(GetStringType(_stat) + champ, PlayerPrefs.GetFloat(GetStringType(_stat) + champ) + 1);
    }

    public static float GetFloatStat(Character _champ, statType _stat)
    {
        string champ = "WX";
        switch (_champ)
        {
            case Character.Re:
                champ = "RE";
                break;

            case Character.Leng:
                champ = "LENG";
                break;
        }

        return PlayerPrefs.GetFloat(GetStringType(_stat) + champ);
    }

    static string GetStringType(statType _stat)
    {
        switch (_stat)
        {
            case statType.Game:
                return "NbrGame";

            case statType.Kill:
                return "NbrKill";

            case statType.Win:
                return "NbrWin";

            case statType.Time:
                return "TimePlayed";

            case statType.Damage:
                return "NbrDamage";
        }

        return "TimePlayed";
    }

    public enum statType{
        Game,
        Kill,
        Win,
        Time,
        Damage
    }
}
