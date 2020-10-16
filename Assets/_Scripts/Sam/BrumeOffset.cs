using UnityEngine;
using System.Collections;

public class BrumeOffset : MonoBehaviour
{
    public Vector2 Scroll = new Vector2(0.00f, 0.05f);
    Vector2 Offset = new Vector2(0f, 0f);

    void Update()
    {
        Offset += Scroll * Time.deltaTime;
        GetComponent<Renderer>().material.SetTextureOffset("_node_2898", Offset);
    }
}