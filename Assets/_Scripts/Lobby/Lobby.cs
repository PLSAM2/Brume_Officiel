using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class Lobby : MonoBehaviour
{
    public TextMeshProUGUI version;

    private void Awake()
    {
        version.text = "v" + Application.version;

        StatFactory.InitStat();
    }

    public void OpenSettings()
    {
        Scene currentScene = SceneManager.GetActiveScene();

        SceneManager.LoadScene("Settings", LoadSceneMode.Additive);
    }
}
