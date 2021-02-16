using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UltPickup : Interactible
{
    [SerializeField] Animator myAnimator;

    private void Start()
    {
        ActualiseMesh();
    }

    public ushort ultimateStackGive = 1;
    public override void Captured(ushort _capturingPlayerID)
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(ultimateStackGive);

            using (Message message = Message.Create(Tags.AddUltimatePoint, writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
            }
        }

        base.Captured(_capturingPlayerID);

    }
    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        base.UpdateCaptured(_capturingPlayerID);
        ActualiseMesh();
    }

    public override void Unlock()
    {
        base.Unlock();
        ActualiseMesh();
    }

    void ActualiseMesh()
    {
        switch (state)
        {
            case State.Locked:
                myAnimator.SetBool("IsActive", false);
                break;

            case State.Capturable:
                myAnimator.SetBool("IsActive", true);
                break;

            case State.Captured:
                myAnimator.SetBool("IsActive", false);
                break;
        }
    }
}
