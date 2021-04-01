using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class GameElement : MonoBehaviour
{
    public Image background;
    public Image lineColor;

    public Image wx;
    public Image re;
    public Image leng;

    public TextMeshProUGUI kda;
    public TextMeshProUGUI victoryLabel;
    public TextMeshProUGUI score;
    public TextMeshProUGUI damage;

    public void Init(StatGame _game, Color _color)
    {
        wx.gameObject.SetActive(_game.champ == Character.WuXin);
        re.gameObject.SetActive(_game.champ == Character.Re);
        leng.gameObject.SetActive(_game.champ == Character.Leng);

        kda.text = "KD " + _game.kill + " / " + _game.death;

        if (_game.yourScore > _game.enemyScore)
        {
            victoryLabel.text = "VICTORY";
        }
        else
        {
            victoryLabel.text = "DEFEAT";
        }

        score.text = _game.yourScore + " - " + _game.enemyScore;
        damage.text = _game.damage.ToString();

        lineColor.color = new Color(_color.r, _color.g, _color.b, lineColor.color.a);
        background.color = new Color(_color.r, _color.g, _color.b, background.color.a);
    }
}
