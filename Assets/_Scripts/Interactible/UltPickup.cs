using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UltPickup : Interactible
{
    [SerializeField] Animator myAnimator;
    public ushort ultimateStackGive = 1;
    public ushort hitPointGiven = 1;

    protected override void Init()
    {
        fillImg.material.SetFloat(progressShaderName, 1);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0.2f);
    }

    private void Start()
    {
        ActualiseMesh();
    }

    public override void TryCapture(GameData.Team team, PlayerModule capturingPlayer)
    {
        //PlayerData _p = NetworkManager.Instance.GetLocalPlayer();

        //if (_p.ultStacks >= GameData.characterUltMax[_p.playerCharacter])
        //{
        //    print(_p.ultStacks + " - " + GameData.characterUltMax[_p.playerCharacter]);
        //    return;
        //}

        base.TryCapture(team, capturingPlayer);

    }
    public override void Captured(ushort _capturingPlayerID)
    {
        //using (DarkRiftWriter writer = DarkRiftWriter.Create())
        //{
        //    writer.Write(ultimateStackGive);

        //    using (Message message = Message.Create(Tags.AddUltimatePoint, writer))
        //    {
        //        NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
        //    }
        //}

        base.Captured(_capturingPlayerID);

    }
    public override void UpdateCaptured(ushort _capturingPlayerID)
    {
        base.UpdateCaptured(_capturingPlayerID);

        GameManager.Instance.networkPlayers[_capturingPlayerID].AddHitPoint(hitPointGiven);

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
