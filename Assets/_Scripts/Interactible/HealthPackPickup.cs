using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class HealthPackPickup : Interactible
{
	NetworkedObject myNetworkedObject;
	[Header("HealValue")]
	[TabGroup("HealPart")]
	public ushort healValue;

	private void Start ()
	{
		myNetworkedObject = GetComponent<NetworkedObject>();
	}

	public override void UpdateCaptured ( GameData.Team team )
	{
		base.UpdateCaptured(team);

		NetworkObjectsManager.Instance.DestroyNetworkedObject(myNetworkedObject.GetItemID());
	}

	public override void Captured ( GameData.Team team )
	{
		capturingPlayerModule.mylocalPlayer.HealPlayer(healValue);
		base.Captured(team);
	}
}
