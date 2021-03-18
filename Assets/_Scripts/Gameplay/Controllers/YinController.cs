﻿using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class YinController : PlayerModule
{
	// [Header("Ying Properties")]

	public GameObject redPart, bluePart;

	public override void Setup ()
	{
		base.Setup();
		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(teamIndex))
			bluePart.SetActive(true);
		else
			redPart.SetActive(true);
	}
}
