using UnityEngine;

public class samTest : MonoBehaviour
{
    public RectTransform img;

    private void Update()
    {
        img.position = Input.mousePosition;
    }

}
