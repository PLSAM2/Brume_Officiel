using UnityEngine;

public class samTest : MonoBehaviour
{
    public Transform obj1;
    public Transform obj2;

    private void Update()
    {
        obj2.rotation = Quaternion.Lerp(obj2.rotation, obj1.rotation, Time.deltaTime * 10);

        obj1.eulerAngles = new Vector3(90, NormalizeAngle(obj1.eulerAngles.y), 0);
    }

    float NormalizeAngle(float angle)
    {
        while (angle > 360)
            angle -= 360;
        while (angle < 0)
            angle += 360;
        return angle;
    }
}
