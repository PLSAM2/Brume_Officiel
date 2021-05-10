using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class PersoAnnoncement : MonoBehaviour
{
    public GameObject re;
    public GameObject leng;
    public GameObject wuxin;

    public Image circleOutline;

    public void Init(Team _team, Character _champ)
    {
        re.SetActive(_champ == Character.Re);
        leng.SetActive(_champ == Character.Leng);
        wuxin.SetActive(_champ == Character.WuXin);

        circleOutline.color = GameFactory.GetRelativeColor(_team);
    }
}
