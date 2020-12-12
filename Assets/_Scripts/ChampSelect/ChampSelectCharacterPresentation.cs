using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChampSelectCharacterPresentation : MonoBehaviour
{
    [SerializeField] GameObject[] Videos;

    public void LoadNewVideo(int id)
    {
        for (int i = 0; i < Videos.Length; i++)
        {
            Videos[i].SetActive(false);
        }

        Videos[id].SetActive(true);
    }

    public void ExitPresentation()
    {
        gameObject.SetActive(false);
    }

}
