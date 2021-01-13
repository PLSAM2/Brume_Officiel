using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class ChatMessageControl : MonoBehaviour
{
    public TextMeshProUGUI timeText;
    public TextMeshProUGUI messageText;
    public PlayerData sender;

    public void InitNewMessage(PlayerData sender, string messageContent)
    {
        this.sender = sender;
        timeText.text = UiManager.Instance.timer.text;
        messageText.text = sender.Name + " : " + messageContent; ;
    }
}
