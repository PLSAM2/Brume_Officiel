using DarkRift;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ChatControl : MonoBehaviour
{
    public GameObject chatMessageObj;
    public GameObject chatMessageLayout;
    public GameObject chatMessagePool;

    public Text messageText;
    public int maxChatMessage = 50;
    public List<ChatMessageControl> chatMessageControls = new List<ChatMessageControl>();

    public void ReceiveNewMessage(ushort _id, string _message)
    {
        GameObject newMessage = GetFirstDisabledObject();
        newMessage.transform.SetParent(chatMessageLayout.transform);
        ChatMessageControl newMessageControl = newMessage.GetComponent<ChatMessageControl>();
        chatMessageControls.Add(newMessageControl);
        CheckMessageLimit(); 
        newMessage.SetActive(true);
        newMessageControl.InitNewMessage(RoomManager.Instance.GetPlayerData(_id), _message);

    }

    public void CheckMessageLimit()
    {
        if (chatMessageControls.Count > maxChatMessage)
        {
            chatMessageControls[0].gameObject.SetActive(false);
        }
    }

    public void SendNewMessage()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(messageText.text);

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
