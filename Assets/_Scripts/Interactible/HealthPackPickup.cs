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

	public override void Captured(ushort _capturingPlayerID)
	{
		base.Captured(_capturingPlayerID);
		capturingPlayerModule.mylocalPlayer.HealPlayer(healValue);
	}

	public override void UpdateCaptured (ushort _capturingPlayerID)
	{
		base.UpdateCaptured(_capturingPlayerID);
		this.gameObject.SetActive(false);
	}

    internal void Reactivate()
    {
		Unlock();
		this.gameObject.SetActive(true);
    }
}
