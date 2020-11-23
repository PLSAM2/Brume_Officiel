using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using static GameData;

public class iconPersoKF : MonoBehaviour
{
    [SerializeField] Image myIconImg;
    [SerializeField] TextMeshProUGUI myUsernameText;

    [SerializeField] Sprite iconShili;
    [SerializeField] Sprite iconYin;
    [SerializeField] Sprite iconYang;

    public void Init(PlayerData p)
    {
        switch (p.playerCharacter)
        {
            case Character.Shili:
                myIconImg.sprite = iconShili;
                break;

            case Character.Yang:
                myIconImg.sprite = iconYang;
                break;

            case Character.Yin:
                myIconImg.sprite = iconYin;
                break;
        }

        myUsernameText.text = p.Name;
    }
}
