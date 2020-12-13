using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
	public Transform myCharacter;

    void Start()
    {
		transform.SetParent(null);
	}

    void Update()
    {
		transform.position = new Vector3(myCharacter.transform.position.x, transform.position.y, myCharacter.transform.position.z);
    }
}
