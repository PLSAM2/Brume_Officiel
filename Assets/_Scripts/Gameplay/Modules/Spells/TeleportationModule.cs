using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportationModule : SpellModule
{
    public bool isTping = false;
    private void Update()
    {
        if (isTping)
        {
            if (Input.GetMouseButtonDown(0))
            {

            }
        }
    }

    protected override void Resolution()
    {
        base.Resolution();

        isTping = true;
    }
}
