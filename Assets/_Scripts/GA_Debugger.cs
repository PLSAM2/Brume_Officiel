using Sirenix.OdinInspector;
using UnityEngine;
using UnityEditor;
public class GA_Debugger : SerializedMonoBehaviour
{
    public bool sw = false;
    public Shader shader;
    public string property;

    public Texture2DArray dArray;
    public void InOutBrumeDebug()
    {
        MeshRenderer[] allObjects = FindObjectsOfType<MeshRenderer>();

        foreach (MeshRenderer R in allObjects)
        {
            if (R.material.shader == shader)
            {
                if (sw)
                {
                    R.material.SetFloat(property, 1);
                } else
                {
                    R.material.SetFloat(property, 0);
                }
            }
        }

        sw = !sw;
    }
}
