using UnityEngine;
using System.Collections;

public class textureAnimTest : MonoBehaviour
{
    public Vector2 Scroll = new Vector2(0.00f, 0.05f);
    Vector2 Offset = new Vector2(0f, 0f);

    public Vector2 Scroll2 = new Vector2(0.0f, 0.08f);
    Vector2 Offset2 = new Vector2(0.15f, 0f);

    void Update()
    {
        Offset += Scroll * Time.deltaTime;
        GetComponent<Renderer>().material.SetTextureOffset("_MainTex3", Offset);
        GetComponent<Renderer>().material.SetTextureOffset("_Mask", Offset);

        Offset2 += Scroll2 * Time.deltaTime;
        GetComponent<Renderer>().material.SetTextureOffset("_MainTex2", Offset2);
    }
}