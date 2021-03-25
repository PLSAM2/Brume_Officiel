using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class EndGameStats : MonoBehaviour
{
	public TextMeshProUGUI countText;

    public void Init()
    {
		countText.text = 0 + "/" + Math.Ceiling((float)(RoomManager.Instance.actualRoom.playerList.Count) / 2);
	}

	public void NewPlayerWantToSkip(ushort count)
    {
		countText.text = count + "/" + Math.Ceiling((float)(RoomManager.Instance.actualRoom.playerList.Count) / 2);

	}

    public void SkipToNextRound()
    {
		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
		{
			using (Message _message = Message.Create(Tags.AskSkipToNextRound, _writer))
			{
				NetworkManager.Instance.GetLocalClient().SendMessage(_message, SendMode.Reliable);
			}
		}
	}
}
