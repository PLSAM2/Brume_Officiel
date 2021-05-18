using UnityEngine;

public class samTest : MonoBehaviour
{
    public Transform child;
    Quaternion oldRotation;

    private void Update()
    {
        child.rotation = Quaternion.Lerp(oldRotation, transform.rotation, Time.time * 1);

        oldRotation = child.rotation;
    }
}
