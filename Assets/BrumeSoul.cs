using DarkRift;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class BrumeSoul : MonoBehaviour
{
    public Character[] authorizedCaptureCharacter = new Character[1];
    public ushort brumeIndex = 100;
    public int instanceID;

    public float lifetime = 10;
    private void Start()
    {
        StartCoroutine(Lifetime());
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule _p = other.gameObject.GetComponent<PlayerModule>();

            if (_p == null || !authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_p.mylocalPlayer.myPlayerId].playerCharacter))
                return;

            PickSoul(_p);
        }
    }


    private void PickSoul(PlayerModule shili)
    {
        WxController wxController = (WxController)shili;

        wxController.PickBrumeSoul();

        Destroy();
    }

    IEnumerator Lifetime()
    {
        yield return new WaitForSeconds(lifetime);

        TryDestroy();
        StartCoroutine(Lifetime());
    }


    private void TryDestroy()
    {
        foreach (LocalPlayer p in GameManager.Instance.networkPlayers.Values)
        {
            if (p.myPlayerModule.isInBrume && p.myPlayerModule.brumeId == instanceID)
            {
                return;
            }
        }

 
    }
    private void Destroy()
    {
        using (DarkRiftWriter Writer = DarkRiftWriter.Create())
        {
            // Recu par les joueurs déja présent dans la room

            Writer.Write(brumeIndex);

            using (Message Message = Message.Create(Tags.BrumeSoulPicked, Writer))
            {
                NetworkManager.Instance.GetLocalClient().SendMessage(Message, SendMode.Reliable);
            }
        }
    }
}
