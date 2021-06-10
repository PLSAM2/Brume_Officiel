using DarkRift;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ChatControl : MonoBehaviour
{
    public GameObject chatMessagePrefab;
    public Transform chatParent;

    public InputField messageText;

    public float timeToFade = 4;

    public Scrollbar myScrollbar;

    public GameObject button;

    private List<ChatMessageControl> chatMessageControls = new List<ChatMessageControl>();

    public bool isFocus = false;

    public void Send()
    {
        if (CheckMessage())
        {
            SendChatMessage();
            UnFocus();
        }
    }

    public void Focus()
    {
        ShowOrHide(true);
        button.SetActive(true);

        isFocus = true;

        messageText.Select();
        messageText.ActivateInputField();
    }

    void ShowOrHide(bool value)
    {
        foreach(ChatMessageControl message in chatMessageControls)
        {
            switch (value)
            {
                case true:
                    message.gameObject.SetActive(true);
                    message.Show();
                    break;

                case false:
                    message.Hide();
                    break;
            }
        }
    }

    public void UnFocus()
    {
        ShowOrHide(false);
        button.SetActive(false);

        isFocus = false;
    }

    public void DisplayMessage(string _message)
    {
        ChatMessageControl newMessageControl = GetNewChatPrefab();
        chatMessageControls.Add(newMessageControl);

        newMessageControl.InitNewServerMessage(_message);

        myScrollbar.value = 0;
    }

    public void ReceiveNewMessage( string _message, ushort _id = 0, bool fromServer = false)
    {
        ChatMessageControl newMessageControl = GetNewChatPrefab();
        chatMessageControls.Add(newMessageControl);

        if (fromServer)
        {
            newMessageControl.InitNewServerMessage(_message);
        } else
        {
            newMessageControl.InitNewMessage(RoomManager.Instance.GetPlayerData(_id), _message);
        }

       // LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)newMessage.transform);

        //if pas en train de l utiliser //TODO
        myScrollbar.value = 0;
    }

    public bool CheckMessage()
    {
        if (messageText.text.Trim(' ') == "")
        {
            return false;
        }

        return true;
    }

    public void SendChatMessage()
    {
        if (!CheckMessage())
        {
            return;
        }

        if (messageText.text.ToLower().Contains("<size") || messageText.text.ToLower().Contains("<color"))
        {
            return;
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(messageText.text);
            _writer.Write(false); // teamOnly
            using (Message _message = Message.Create(Tags.NewChatMessage, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }

        messageText.text = "";
    }

    public void SendNewForcedMessage(string message, bool teamOnly = false)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(message);
            _writer.Write(teamOnly);

            using (Message _message = Message.Create(Tags.NewChatMessage, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }
    }
    private ChatMessageControl GetNewChatPrefab()
    {
        return Instantiate(chatMessagePrefab, chatParent).GetComponent<ChatMessageControl>();
    }
}
