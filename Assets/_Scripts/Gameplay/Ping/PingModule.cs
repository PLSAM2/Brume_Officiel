﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingModule : SpellModule
{
    private void Update()
    {
        if (myPlayerModule == null || isOwner == false)
        {
            return;
        }

        if (charges > 0)
        {
            if (Input.GetKeyDown(myPlayerModule.pingKey))
            {
                UiManager.Instance.uIPingModule.Init();
            }
            if (Input.GetKey(myPlayerModule.pingKey))
            {
                UiManager.Instance.uIPingModule.PingChoiceHold();
            }
            if (Input.GetKeyUp(myPlayerModule.pingKey))
            {
                DecreaseCharge();
                UiManager.Instance.uIPingModule.Desactivate();
            }
        }
        else
        {
            if (Input.GetKeyDown(myPlayerModule.pingKey))
            {
                UiManager.Instance.chat.ReceiveNewMessage("No Ping available.. Wait...", 0, true);
            }
        }
    }
}
