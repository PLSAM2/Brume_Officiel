using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class Lobby : MonoBehaviour
{
    private void Awake()
    {
        StatFactory.InitStat();
    }

    public void OpenSettings()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        print(currentScene.name);

        SceneManager.LoadScene("Settings", LoadSceneMode.Additive);
    }
}
