using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoulBurst_Pickup : Interactible
{

	NetworkedObject myNetworkedObject;

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
		WxController _temp = (WxController)capturingPlayerModule;
		_temp.soulPickedUp.Invoke();
		base.Captured(team);
	}
}
