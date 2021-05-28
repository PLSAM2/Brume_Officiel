using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using TMPro;
using UnityEngine;
using static GameData;
using static StatFactory;

public class StatMenu : MonoBehaviour
{
    public LabelStatElement currentLabel;

    public GameObject champ;
    public GameObject stat;
    public GameObject game;

    public TextMeshProUGUI timePlayedLocal;
    public TextMeshProUGUI gameLocal;
    public TextMeshProUGUI winLocal;
    public TextMeshProUGUI killLocal;
    public TextMeshProUGUI damageLocal;
    public TextMeshProUGUI captureNbr;

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

    //Games
    public Color winColor;
    public Color defeatColor;

    public Transform parentList;

    public GameObject gamePrefab;


    void Start()
    {
        InitStat();
        InitGames();
    }

    public void OpenChamp(LabelStatElement _currentLabel)
    {
        RefreshLabel(_currentLabel);

        champ.SetActive(true);
        stat.SetActive(false);
        game.SetActive(false);
    }

    public void OpenStat(LabelStatElement _currentLabel)
    {
        RefreshLabel(_currentLabel);

        champ.SetActive(false);
        stat.SetActive(true);
        game.SetActive(false);
    }

    public void OpenGame(LabelStatElement _currentLabel)
    {
        RefreshLabel(_currentLabel);

        champ.SetActive(false);
        stat.SetActive(false);
        game.SetActive(true);
    }

    void RefreshLabel(LabelStatElement _currentLabel)
    {
        if (currentLabel)
        {
            currentLabel.Disable();
        }

        currentLabel = _currentLabel;
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
            winLocal.text = Mathf.RoundToInt(StatFactory.GetTotalNbrWin() / (float)StatFactory.GetTotalNbrGame() * 100) .ToString();
        }

        killLocal.text = StatFactory.GetTotalNbrKill().ToString();
        damageLocal.text = StatFactory.GetTotalNbrDamage().ToString();
        captureNbr.text = StatFactory.GetCaptureNbr().ToString();

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
            _win.text = Mathf.RoundToInt(StatFactory.GetIntStat(_charac, statType.Win) / (float)StatFactory.GetIntStat(_charac, statType.Game) * 100) + "<size=20>%</size>";
        }

        _kill.text = StatFactory.GetIntStat(_charac, statType.Kill).ToString();
        _damage.text = StatFactory.GetIntStat(_charac, statType.Damage).ToString();
    }

    void InitGames()
    {
        if (!Directory.Exists(Application.persistentDataPath + "/Games"))
        {
            return;
        }

        List<StatGame> allGames = new List<StatGame>();
        try
        {
            string input = File.ReadAllText(Application.persistentDataPath + "/Games/allGames.json");
            List<StatGame> temp = JsonConvert.DeserializeObject<List<StatGame>>(input);
            allGames.AddRange(temp);
        }
        catch
        {
            return;
        }


        foreach(StatGame game in allGames)
        {
            GameElement newGame = Instantiate(gamePrefab, parentList).GetComponent<GameElement>();
            newGame.Init(game, (game.yourScore > game.enemyScore ? winColor : defeatColor));
        }
    }
}
