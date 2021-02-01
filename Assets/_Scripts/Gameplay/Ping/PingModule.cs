using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingModule : MonoBehaviour
{
    public KeyCode pingKey;

    private void Update()
    {
        if (Input.GetKeyDown(pingKey))
        {
            UiManager.Instance.uIPingModule.Init();
        }

        if (Input.GetKey(pingKey))
        {
            UiManager.Instance.uIPingModule.PingChoiceHold();
        }

        if (Input.GetKeyUp(pingKey))
        {
            UiManager.Instance.uIPingModule.Desactivate();
        }
    }
}
