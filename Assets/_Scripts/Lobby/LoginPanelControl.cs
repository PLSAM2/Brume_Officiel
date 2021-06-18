using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using TMPro;
using UnityEngine;
using UnityEngine.UI;


public enum ConnectTarget : ushort
{
    Online = 0,
    Local = 1,
    LocalHost = 2
}

public class LoginPanelControl : MonoBehaviour
{
    public bool autoConnect = true;
    [ShowIf("autoConnect")] public ConnectTarget connectTarget;

    [SerializeField] private TMP_InputField nameLoginInputField;
    [SerializeField] private TextMeshProUGUI connectionStateLogin;
    [SerializeField] private Button loginBtn;
    [SerializeField] private UnityClient client;
    [SerializeField] private GameObject nameChangePanel;
    [SerializeField] private List<GameObject> connectButtons;
    [SerializeField] private GameObject loadingImg;
    [SerializeField] private TextMeshProUGUI loadingTxt;

    public IPAddress LocalIP
    {
        get { return IPAddress.Parse(localIP); }
        set { localIP = value.ToString(); }
    }

    [SerializeField]
    [Tooltip("The address of the server to connect to (LOCAL).")]
    private string localIP = IPAddress.Loopback.ToString();

    public IPAddress LocalHostIP
    {
        get { return IPAddress.Parse(localHostIP); }
        set { localHostIP = value.ToString(); }
    }

    [SerializeField]
    [Tooltip("The address of the localhost server to connect to.")]
    private string localHostIP = IPAddress.Loopback.ToString();

    private void Awake()
    {
        client = RoomManager.Instance.client;
    }

    private void Start()
    {
        if (client.ConnectionState == ConnectionState.Connected)
        {
            this.gameObject.SetActive(false);
            LobbyManager.Instance.DisplayMainMenu();
        }
        else
        {
            if (autoConnect)
            {
                switch (connectTarget)
                {
                    case ConnectTarget.Online:
                        ConnectOnline();
                        break;
                    case ConnectTarget.Local:
                        ConnectLocal();
                        break;
                    case ConnectTarget.LocalHost:
                        ConnectLocalHost();
                        break;
                    default: throw new Exception("Connection target not existing");
                }
            }
        }
    }

    public void ConnectOnline()
    {
        TryConnect();
        try
        {
            client.ConnectInBackground(client.Address, client.Port, true, Connected);
        }
        catch (SocketException e)
        {
            Debug.LogError(e);
        }
    }

    public void ConnectLocal()
    {
        TryConnect();
        try
        {
            client.ConnectInBackground(LocalIP, client.Port, true, Connected);
        }
        catch (SocketException e)
        {
            Debug.LogError(e);
        }
    }

    public void ConnectLocalHost()
    {
        TryConnect();
        try
        {
            client.ConnectInBackground(LocalHostIP, client.Port, true, Connected);
        }
        catch (SocketException e)
        {
            Debug.LogError(e);
        }
    }

    private void TryConnect()
    {
        loadingTxt.text = "Connecting";
        loadingTxt.color = Color.white;
        loadingTxt.gameObject.SetActive(true);
        loadingImg.gameObject.SetActive(true);

        foreach (GameObject go in connectButtons)
        {
            go.SetActive(false);
        }
    }

    private void Connected(Exception e)
    {
        if (e != null)
        {
            loadingTxt.text = "Error connecting";
            loadingTxt.color = Color.red;
            loadingImg.gameObject.SetActive(false);

            foreach (GameObject go in connectButtons)
            {
                go.SetActive(true);
            }

            client.Disconnect();
            client.Close();
        }
        else
        {
            nameChangePanel.SetActive(true);
            loadingImg.SetActive(false);
            connectionStateLogin.gameObject.SetActive(false);
            loadingTxt.gameObject.SetActive(false);


            //if (PlayerPrefs.GetString("PlayerName") != null && PlayerPrefs.GetString("PlayerName") != "")
            //{
            //    Login(PlayerPrefs.GetString("PlayerName"));
            //}
            //else
            //{
            nameChangePanel.SetActive(true);
                loginBtn.interactable = true;
            //}
        }
    }


    void FixedUpdate()
    {
        connectionStateLogin.text = client.ConnectionState.ToString();

        if (client.ConnectionState != ConnectionState.Connected)
        {
            //loginBtn.interactable = false;
            //nameChangePanel.SetActive(false);

            //foreach (GameObject go in connectButtons)
            //{
            //    go.SetActive(true);
            //}
            return;
        }
        //else
        //{
        //    nameChangePanel.SetActive(true);

        //    foreach (GameObject go in connectButtons)
        //    {
        //        go.SetActive(false);
        //    }
        //    loginBtn.interactable = true;
        //}



        if (Input.GetKeyDown(KeyCode.Return))
        {
            Login();
        }
    }


    public void Restart()
    {
        nameChangePanel.SetActive(true);
        loadingImg.SetActive(false);
        connectionStateLogin.gameObject.SetActive(false);
        loadingTxt.gameObject.SetActive(false);

        foreach (GameObject go in connectButtons)
        {
            go.SetActive(false);
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
        //LobbyManager.Instance.StartPrivateRoom(false);
        LobbyManager.Instance.DisplayMainMenu();
    }




}
