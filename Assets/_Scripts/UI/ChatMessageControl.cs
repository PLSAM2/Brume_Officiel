using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class ChatMessageControl : MonoBehaviour
{
    public TextMeshProUGUI messageText;
    public PlayerData sender;

    [SerializeField] Animator myAnimator;

    [SerializeField] float displayTime = 4;

    bool isAppear = false;

    public void DisableMe()
    {
        gameObject.SetActive(false);
    }

    public void Show()
    {
        StopAllCoroutines();
        myAnimator.SetBool("Show", true);
    }

    public void InitNewMessage(PlayerData sender, string messageContent)
    {
        this.sender = sender;
        string name = "";

        switch (sender.playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            case true:
                name += "<color=" + GameFactory.GetColorTeamInHex(GameData.Team.blue) + ">";
                break;

            case false:
                name += "<color=" + GameFactory.GetColorTeamInHex(GameData.Team.red) + ">";
                break;
        }

        name += sender.Name + " (" + sender.playerCharacter.ToString() + ") : </color>";

        messageText.text = "<color=white>[" + (int)GameManager.Instance.timer % 60 + ":"+ (int)Math.Floor(GameManager.Instance.timer / 60) + "] </color>" + name + messageContent;

        StartCoroutine(HideThis());
    }

    public void InitNewServerMessage(string messageContent)
    {
        this.sender = sender;
        messageText.text = "<color=white>[" + UiManager.Instance.timer.text + "] </color>" + "SERVER : " + messageContent;

        StartCoroutine(HideThis());
    }

    public void Hide()
    {
        StartCoroutine(HideThis());
    }

    IEnumerator HideThis()
    {
        yield return new WaitForSeconds(displayTime);

        if (!UiManager.Instance.chat.isFocus)
        {
            myAnimator.SetBool("Show", false);
        }
    }
}
