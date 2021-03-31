﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Lobby : MonoBehaviour
{
    private void Awake()
    {
        StatFactory.InitStat();
    }

    public void OpenSettings()
    {
        SceneManager.LoadScene("Settings", LoadSceneMode.Additive);
    }
}
