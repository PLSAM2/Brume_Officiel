using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class UIDecoy : MonoBehaviour
{
    public TextMeshProUGUI nameText;

    public Transform parentListLife;
    public GameObject prefabLifeBar;
    List<GameObject> uiLifeElements = new List<GameObject>();


    public Material blueMat, redMat, grayMat;
    Material currentColorTeam;

    public void Init(Team _team, string _name, int _liveHealth, int _maxLiveHealth)
    {
        currentColorTeam = redMat;
        if (GameFactory.GetRelativeTeam(_team) == Team.blue)
        {
            currentColorTeam = blueMat;
        }

        nameText.text = _name;
        nameText.material = currentColorTeam;

        SpawnLifeBar(_liveHealth, _maxLiveHealth, _team);
    }

    void SpawnLifeBar(int _liveHealth, int _maxLiveHealth, Team _team)
    {
        foreach(GameObject obj in uiLifeElements)
        {
            Destroy(obj);
        }

        for (int i = 0; i < _maxLiveHealth; i++)
        {
            UIBarLifePerso img = Instantiate(prefabLifeBar, parentListLife).GetComponent<UIBarLifePerso>();

            if (i < _liveHealth)
            {
                img.SetColorLife(currentColorTeam, true);
            }
            else
            {
                img.CrackLife();
                img.SetColorLife(grayMat, false);
                img.HideLife();
            }

            uiLifeElements.Add(img.gameObject);
        }
    }
}
