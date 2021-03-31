using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;
using static StatFactory;

public class StatMenu : MonoBehaviour
{
    public Animator champLabel;
    public Animator statLabel;
    public Animator gamesLabel;

    public GameObject champ;
    public GameObject stat;
    public GameObject game;

    public TextMeshProUGUI timePlayedLocal;
    public TextMeshProUGUI gameLocal;
    public TextMeshProUGUI winLocal;
    public TextMeshProUGUI killLocal;
    public TextMeshProUGUI damageLocal;

    //WX
    public TextMeshProUGUI timePlayedWX;
    public TextMeshProUGUI gameWX;
    public TextMeshProUGUI winWX;
    public TextMeshProUGUI killWX;
    public TextMeshProUGUI damagesWX;

    //RE
    public TextMeshProUGUI timePlayedRE;
    public TextMeshProUGUI gameRE;
    public TextMeshProUGUI winRE;
    public TextMeshProUGUI killRE;
    public TextMeshProUGUI damagesRE;

    //LENG
    public TextMeshProUGUI timePlayedLENG;
    public TextMeshProUGUI gameLENG;
    public TextMeshProUGUI winLENG;
    public TextMeshProUGUI killLENG;
    public TextMeshProUGUI damagesLENG;

    // Start is called before the first frame update
    void Start()
    {
        champLabel.SetBool("IsOpen", true);
        statLabel.SetBool("IsOpen", false);
        gamesLabel.SetBool("IsOpen", false);

        InitStat();
    }

    public void OpenChamp()
    {
        champLabel.SetBool("IsOpen", true);
        statLabel.SetBool("IsOpen", false);
        gamesLabel.SetBool("IsOpen", false);

        champ.SetActive(true);
        stat.SetActive(false);
        game.SetActive(false);
    }

    public void OpenStat()
    {
        champLabel.SetBool("IsOpen", false);
        statLabel.SetBool("IsOpen", true);
        gamesLabel.SetBool("IsOpen", false);

        champ.SetActive(false);
        stat.SetActive(true);
        game.SetActive(false);
    }

    public void OpenGame()
    {
        champLabel.SetBool("IsOpen", false);
        statLabel.SetBool("IsOpen", false);
        gamesLabel.SetBool("IsOpen", true);

        champ.SetActive(false);
        stat.SetActive(false);
        game.SetActive(true);
    }


    void InitStat()
    {
        timePlayedLocal.text = StatFactory.GetTotalTimePlayed() + "<size=60> MIN</size>";
        gameLocal.text = StatFactory.GetTotalNbrGame().ToString();


        if (StatFactory.GetTotalNbrWin() == 0)
        {
            winLocal.text = "0";
        }
        else
        {
            winLocal.text = Mathf.RoundToInt((float) StatFactory.GetTotalNbrWin() / (float) StatFactory.GetTotalNbrGame() ).ToString();
        }

        killLocal.text = StatFactory.GetTotalNbrKill().ToString();
        damageLocal.text = StatFactory.GetTotalNbrDamage().ToString();


        DisplayStat(Character.WuXin, timePlayedWX, gameWX, winWX, killWX, damagesWX);
        DisplayStat(Character.Re, timePlayedRE, gameRE, winRE, killRE, damagesRE);
        DisplayStat(Character.Leng, timePlayedLENG, gameLENG, winLENG, killLENG, damagesLENG);
    }

    void DisplayStat(Character _charac, TextMeshProUGUI _time, TextMeshProUGUI _game, TextMeshProUGUI _win, TextMeshProUGUI _kill, TextMeshProUGUI _damage)
    {
        _time.text = StatFactory.GetIntStat(_charac, statType.Time) + "<size=20> MIN</size>\n<size=25>Time played</size>";
        _game.text = StatFactory.GetIntStat(_charac, statType.Game).ToString();

        if(StatFactory.GetIntStat(_charac, statType.Game) == 0)
        {
            _win.text = "0<size=20>%</size>";
        }
        else
        {
            _win.text = Mathf.RoundToInt((float)StatFactory.GetIntStat(_charac, statType.Win) / (float)StatFactory.GetIntStat(_charac, statType.Game)) + "<size=20>%</size>";
        }

        _kill.text = StatFactory.GetIntStat(_charac, statType.Kill).ToString();
        _damage.text = StatFactory.GetIntStat(_charac, statType.Damage).ToString();
    }
}
