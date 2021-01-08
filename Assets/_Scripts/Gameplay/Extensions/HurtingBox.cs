using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HurtingBox : MonoBehaviour
{
	List<GameObject> allHits;
	 public HurtingDash myHurtingDash;

	private void Start ()
	{
		allHits = new List<GameObject>();
	}

	public void ResetHitbox ()
	{
		allHits = new List<GameObject>();
	}


	private void OnDisable ()
	{
		ResetHitbox();
	}

	private void OnTriggerEnter ( Collider other )
	{
		PlayerModule _temp = other.GetComponent<PlayerModule>();

		if(!allHits.Contains(_temp.gameObject))
		{
			if (_temp != null)
				allHits.Add(_temp.gameObject);

			if (_temp.teamIndex != myHurtingDash.myPlayerModule.teamIndex)
			{
				myHurtingDash.TouchedAnEnemy(_temp);
			}
		}
		
	}
}
