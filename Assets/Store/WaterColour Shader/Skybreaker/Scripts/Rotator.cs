using UnityEngine;
using System.Collections;

public class Rotator : MonoBehaviour {

	public Vector3 rotationDegrees;
	public bool localSpace = false;


	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () 
	{
		transform.Rotate(rotationDegrees*Time.deltaTime, (localSpace?Space.Self:Space.World));
	}
}
