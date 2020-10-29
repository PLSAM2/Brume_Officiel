using UnityEngine;
using System.Collections;

public class CameraWobble : MonoBehaviour 
{
	public float wobbleAmount = 0.025f;
	public float speedMulti = 0.25f;
	private Vector3 initPos;

	// Use this for initialization
	void Start () 
	{
		initPos = transform.position;
	}
	
	// Update is called once per frame
	void Update () 
	{
		Vector3 offset = Mathf.Sin (Time.time*2f*speedMulti) * Vector3.right * wobbleAmount;
		offset += Mathf.Sin (Time.time*1.5f*speedMulti) * Vector3.up * wobbleAmount;
		offset += Mathf.Sin (Time.time*1.8f*speedMulti) * Vector3.forward * wobbleAmount;
		transform.position = initPos + offset;
	}
}
