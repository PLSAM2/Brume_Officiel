﻿using DarkRift;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class LoginPanelControl : MonoBehaviour
{

    public float timeFirstAttempt = 6;
    public float timeBeforeReconnect = 4;
    public IPAddress LocalIP
    {
        get { return IPAddress.Parse(localIP); }
        set { localIP = value.ToString(); }
    }

    [SerializeField]
    [Tooltip("The address of the server to connect to.")]
    private string localIP = IPAddress.Loopback.ToString();

    [SerializeField] private TMP_InputField nameLoginInputField;
    [SerializeField] private TextMeshProUGUI connectionStateLogin;
    [SerializeField] private Button loginBtn;
    [SerializeField] private UnityClient client;

    public void ConnectOnline()
    {
        try
        {
            client.Connect(client.Address, client.Port, true);
        }
        catch (SocketException e)
        {
            Debug.LogError(e);
        }
         
    }

    public void ConnectLocal()
    {
        try
        {
            client.Connect(LocalIP, client.Port, true);
        }
        catch (SocketException e)
        {
            Debug.LogError(e);
        }

    }
    void Update()
    {
        connectionStateLogin.text = client.ConnectionState.ToString();

        if (client.ConnectionState != ConnectionState.Connected)
        {
            loginBtn.interactable = false;
            return;
        }
        else
        {
            loginBtn.interactable = true;
        }

        if (PlayerPrefs.GetString("PlayerName") != null && PlayerPrefs.GetString("PlayerName") != "")
        {
            Login(PlayerPrefs.GetString("PlayerName"));
        }

        if (Input.GetKeyDown(KeyCode.Return))
        {
            Login();
        }
    }

    public void Login(string name = "")
    {
        if (name == "")
        {
            name = nameLoginInputField.text;
        }

        LobbyManager.Instance.CheckName(ref name);
        LobbyManager.Instance.ChangeName(name);

        this.gameObject.SetActive(false);
        LobbyManager.Instance.DisplayMainMenu();
    }


}
