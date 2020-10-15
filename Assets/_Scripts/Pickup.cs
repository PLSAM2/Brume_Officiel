using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
	[SerializeField] GameObject particleOnPickedUp;
	LocalPlayer playerTouched;
	private void OnTriggerEnter ( Collider other )
	{
	


		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID(), true);
		playerTouched = other.GetComponent<LocalPlayer>();
	}


	private void OnDestroy ()
	{
		GameManager.Instance.AddPoints(playerTouched.teamIndex, 1);
		//Instantiate(particleOnPickedUp, transform.position, Quaternion.identity);
	}
}
