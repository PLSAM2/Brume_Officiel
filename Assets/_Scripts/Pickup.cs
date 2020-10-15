using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
	[SerializeField] GameObject particleOnPickedUp;

	private void OnTriggerEnter ( Collider other )
	{
		GameManager.Instance.AddPoints(other.GetComponent<LocalPlayer>().teamIndex, 1);


		print("A caler une fois la fonction faite");
		NetworkObjectsManager.Instance.DestroyNetworkedObject(GetComponent<NetworkedObject>().GetItemID());
	}


	private void OnDestroy ()
	{
		Instantiate(particleOnPickedUp, transform.position, Quaternion.identity);
	}
}
