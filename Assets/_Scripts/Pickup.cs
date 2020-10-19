using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
	[SerializeField] GameObject particleOnPickedUp;
	LocalPlayer playerTouched;
	Transform transformToSend;

	private void OnEnable ()
	{
		transformToSend = transform;
	}

	private void OnTriggerEnter ( Collider other )
	{
		playerTouched = other.GetComponent<LocalPlayer>();

		if (playerTouched.isOwner)
			GameManager.Instance.AddPoints(playerTouched.myPlayerModule.teamIndex, 1);
		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID(), true); 
		Instantiate(particleOnPickedUp, transform.position, Quaternion.identity);

	}

	private void OnDestroy ()
	{
		LevelManager.instance.KillPickup(transformToSend);
	}

}
