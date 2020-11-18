using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    [SerializeField] Team myTeam;

    void Start()
    {
        GetComponent<Image>().color = GameFactory.GetColorTeam(myTeam);
    }
}
