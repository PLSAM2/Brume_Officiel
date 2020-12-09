using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System;

public class HealthPackPickup : Interactible
{
	[Header("HealValue")]
	[TabGroup("HealPart")]
	public ushort healValue;

	public override void Captured(GameData.Team team)
	{
		base.Captured(team);
		capturingPlayerModule.mylocalPlayer.HealPlayer(healValue);
	}

	public override void UpdateCaptured ( GameData.Team team )
	{
		base.UpdateCaptured(team);
		this.gameObject.SetActive(false);
	}

    internal void Reactivate()
    {
		Unlock();
		this.gameObject.SetActive(true);
    }
}
