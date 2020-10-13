using DarkRift;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using TMPro;
using UnityEditor.PackageManager;
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

    private bool isTryingToConnectFirstTime = true;
    private bool isTryingToReconnect = false;
    private int attempt = 0;

    private void Start()
    {
        client.Connect(client.Address, client.Port, true);

        StartCoroutine(TimerBeforeConnectingFirstTime());
    }
    void Update()
    {
        connectionStateLogin.text = client.ConnectionState.ToString();

        if (client.ConnectionState != ConnectionState.Connected)
        {
            if (!isTryingToConnectFirstTime)
            {
                StartCoroutine(TryReconnect());
            }

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

    IEnumerator TryReconnect()
    {
        isTryingToReconnect = true;

        if (client.ConnectionState != ConnectionState.Connected)
        {
            attempt++;

            if (attempt % 2 == 0)
            {
                client.Connect(client.Address, client.Port, true);
                Debug.Log("Reconnecting at => " + client.Address);
            }
            else
            {
                client.Connect(LocalIP, client.Port, true);
                Debug.Log("Reconnecting at => " + LocalIP);
            }

            Debug.Log("Reconnecting after " + timeBeforeReconnect + " | attempt : " + attempt);
        }

        yield return new WaitForSeconds(timeBeforeReconnect);

        isTryingToReconnect = false;
    }
    IEnumerator TimerBeforeConnectingFirstTime()
    {
        yield return new WaitForSeconds(timeFirstAttempt);

        if (client.ConnectionState != ConnectionState.Connected)
        {
            isTryingToConnectFirstTime = false;
        }

    }
}
