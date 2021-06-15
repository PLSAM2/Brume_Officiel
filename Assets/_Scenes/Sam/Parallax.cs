using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Parallax : MonoBehaviour
{
    Vector3 _pos;
    Vector3 _startPos;

    public float modifier;
    public float modifierY;

    public bool isRotation = false;

    void Start()
    {
        _startPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 pos = Camera.main.ScreenToViewportPoint(Input.mousePosition);
        pos.z = 0;

        if (!isRotation)
        {
            transform.position = pos;
            transform.position = new Vector3(_startPos.x - (pos.x * modifier), _startPos.y - (pos.y * modifier), 0);
        }
        else
        {
            transform.localEulerAngles = new Vector3(pos.y * modifierY, pos.x * modifier, 0);
        }
    }
}
