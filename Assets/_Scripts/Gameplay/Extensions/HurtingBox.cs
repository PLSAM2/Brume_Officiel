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
		if (!allHits.Contains(other.gameObject))
		{
			allHits.Add(other.gameObject);
			myHurtingDash.TouchedAnEnemy(other.gameObject);
		}

	}
}
