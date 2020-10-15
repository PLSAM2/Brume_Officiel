using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
	[SerializeField] GameObject particleOnPickedUp;

	private void OnTriggerEnter ( Collider other )
	{
	

		print(other);

		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID(), true);

	}


	private void OnDestroy ()
	{
		GameManager.Instance.AddPoints(other.GetComponent<LocalPlayer>().teamIndex, 1);
		//Instantiate(particleOnPickedUp, transform.position, Quaternion.identity);
	}
}
