using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class LoginPanelControl : MonoBehaviour
{

    [SerializeField] private TMP_InputField nameLoginInputField;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            Login();
        }
    }

    public void Login()
    {
        string name = nameLoginInputField.text;
        LobbyManager.Instance.CheckName(ref name);
        LobbyManager.Instance.Login(name);

    }
}
