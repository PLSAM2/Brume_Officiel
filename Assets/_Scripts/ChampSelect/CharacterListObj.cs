using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class CharacterListObj : MonoBehaviour
{
    public GameObject SwapImg;
    public TextMeshProUGUI playerNameText;
    public TextMeshProUGUI characterNameText;
    public Character character;

    private void Start()
    {
        characterNameText.text = character.ToString();
    }

    public void PickCharacter()
    {
        ChampSelectManager.Instance.PickCharacter(character);
    }
}
