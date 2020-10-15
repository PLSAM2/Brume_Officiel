using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
	[SerializeField] GameObject particleOnPickedUp;
	LocalPlayer playerTouched;
	private void OnTriggerEnter ( Collider other )
	{
		playerTouched = other.GetComponent<LocalPlayer>();

		if (playerTouched.isOwner)
			GameManager.Instance.AddPoints(playerTouched.teamIndex, 1);
		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID(), true);
	}


	private void OnDestroy ()
	{
	
		Instantiate(particleOnPickedUp, transform.position, Quaternion.identity);
	}
}
