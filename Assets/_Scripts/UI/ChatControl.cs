using DarkRift;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ChatControl : MonoBehaviour
{
    public GameObject chatMessageObj;
    public GameObject chatMessageLayout;
    public GameObject chatMessagePool;

    public InputField messageText;
    public int maxChatMessage = 50;
    [Header("Fade / Display")]
    public List<Image> imageToFadeDisplay = new List<Image>();
    public List<Text> textToFadeDisplay = new List<Text>();
    public Image chatMessageImage;
    public float timeToFade = 4;
    public float maxColorOpacity = 0.75f;
    public GameObject NoClickImage;

    private List<ChatMessageControl> chatMessageControls = new List<ChatMessageControl>();
    private bool isFocused = false;
    private bool endEditAndSend = false;
    private bool sendAfter = false;

    private bool stunnedStateGive = false;
    private float timer = 0;
    public void Focus()
    {
        if (sendAfter)
        {
            sendAfter = false;
            SendNewMessage();
        }
        if (isFocused == false && endEditAndSend == false)
        {
            stunnedStateGive = true;
            GameFactory.GetLocalPlayerObj().myPlayerModule.AddState(En_CharacterState.Stunned);
            isFocused = true;
            DisplayChat();
            messageText.Select();
            messageText.ActivateInputField();
        }

        if (endEditAndSend)
        {
            stunnedStateGive = false;
            GameFactory.GetLocalPlayerObj().myPlayerModule.RemoveState(En_CharacterState.Stunned);
            endEditAndSend = false;
        }

    }
    public void UnFocus()
    {
        if (CheckMessage())
        {
            sendAfter = true;
        } else
        {
            endEditAndSend = true;
            if (!EventSystem.current.alreadySelecting) EventSystem.current.SetSelectedGameObject(null);
            timer = timeToFade;
        }

        isFocused = false;
    }

    public void DisplayChat()
    {
        FadeDisplayProgress(maxColorOpacity, true);
    }

    private void FixedUpdate()
    {
        if (isFocused)
        {
            NoClickImage.SetActive(false);
        }
        if (isFocused == false)
        {
            if (stunnedStateGive == true)
            {
                stunnedStateGive = false;
                GameFactory.GetLocalPlayerObj().myPlayerModule.RemoveState(En_CharacterState.Stunned);
            }

            if (timer >= 0)
            {
                timer -= Time.fixedDeltaTime;
                FadeDisplayProgress(timer / timeToFade);
            } else
            {
                NoClickImage.SetActive(true);
                FadeDisplayProgress(0);
            }
        }
    }

    public void FadeDisplayProgress(float value, bool ignoreMaxOpacity = false)
    {
        if (ignoreMaxOpacity)
        {
            for (int i = 0; i < imageToFadeDisplay.Count; i++)
            {
                imageToFadeDisplay[i].color = new Color(imageToFadeDisplay[i].color.r, imageToFadeDisplay[i].color.g, imageToFadeDisplay[i].color.b, value);
            }
            for (int i = 0; i < textToFadeDisplay.Count; i++)
            {
                textToFadeDisplay[i].color = new Color(textToFadeDisplay[i].color.r, textToFadeDisplay[i].color.g, textToFadeDisplay[i].color.b, value);
            }
        } else
        {
            for (int i = 0; i < imageToFadeDisplay.Count; i++)
            {
                imageToFadeDisplay[i].color = new Color(imageToFadeDisplay[i].color.r, imageToFadeDisplay[i].color.g, imageToFadeDisplay[i].color.b, value * maxColorOpacity);
            }
            for (int i = 0; i < textToFadeDisplay.Count; i++)
            {
                textToFadeDisplay[i].color = new Color(textToFadeDisplay[i].color.r, textToFadeDisplay[i].color.g, textToFadeDisplay[i].color.b, value * maxColorOpacity);
            }
        }

      
         chatMessageImage.color = new Color(chatMessageImage.color.r, chatMessageImage.color.g, chatMessageImage.color.b, value * 0.05f);
    }

    public void ReceiveNewMessage( string _message, ushort _id = 0, bool fromServer = false)
    {
        timer = 4;
        GameObject newMessage = GetFirstDisabledObject();
        newMessage.transform.SetParent(chatMessageLayout.transform);
        ChatMessageControl newMessageControl = newMessage.GetComponent<ChatMessageControl>();
        chatMessageControls.Add(newMessageControl);
        CheckMessageLimit();
        newMessage.SetActive(true);

        if (fromServer)
        {
            newMessageControl.InitNewServerMessage(_message);
        } else
        {
            newMessageControl.InitNewMessage(RoomManager.Instance.GetPlayerData(_id), _message);
        }

        newMessage.GetComponent<RectTransform>().localScale = Vector3.one;
        LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)chatMessageLayout.transform);
        LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)newMessage.transform);
    }

    public bool CheckMessageLimit()
    {
        if (chatMessageControls.Count > maxChatMessage)
        {
            chatMessageControls[0].gameObject.SetActive(false);
            return false;
        }
        return true;
    }

    public bool CheckMessage()
    {
        if (messageText.text.Trim(' ') == "")
        {
            return false;
        }

        return true;
    }

    public void SendNewMessage()
    {
        if (!CheckMessage())
        {
            return;
        }

        if (messageText.text.ToLower().Contains("<size"))
        {
            messageText.text = "JE SUIS UN PETIT FOU";
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(messageText.text);

            using (Message _message = Message.Create(Tags.NewChatMessage, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }

        messageText.text = "";
    }

    public void SendNewForcedMessage(string message)
    {
        timer = 4;

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(message);

            using (Message _message = Message.Create(Tags.NewChatMessage, _writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
            }
        }
    }
    private GameObject GetFirstDisabledObject()
    {
        foreach (Transform t in chatMessagePool.gameObject.transform)
        {
            if (!t.gameObject.activeInHierarchy)
            {
                return t.gameObject;
            }
        }

        GameObject newobj = Instantiate(chatMessageObj, chatMessagePool.gameObject.transform);

        return newobj;
    }



}
