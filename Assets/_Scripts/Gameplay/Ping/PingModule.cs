using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingModule : SpellModule
{
    public KeyCode pingKey;

    private void Update()
    {
        if (charges > 0)
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
                Resolution();
                UiManager.Instance.uIPingModule.Desactivate();
            }
        }
    }

}
