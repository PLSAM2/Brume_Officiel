using UnityEngine;
using System.Collections;

public class RandomSphericalPosition : MonoBehaviour {

    private Vector3 startPosition;
    public float interval = 1f;
    public float radius = 2f;

	// Use this for initialization
	void Start () {
        startPosition = this.transform.position;
        InvokeRepeating("setPosition", 1f, interval);
	}

    void setPosition()
    {
        Debug.Log("+");
        this.transform.position = startPosition+ Random.insideUnitSphere * radius;
    }
}
