using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpecMode : MonoBehaviour
{
    List<SpecPlayerElement> listPlayer = new List<SpecPlayerElement>();

    [SerializeField] GameObject prefabPlayer;

    private void OnEnable()
    {
        
    }

    void RefreshList()
    {
        foreach(SpecPlayerElement oldPlayer in listPlayer)
        {
            Destroy(oldPlayer.gameObject);
        }

        foreach(KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if(RoomManager.Instance.GetPlayerData(player.Key).playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam) {

                if(player.Value == GameManager.Instance.currentLocalPlayer) { continue; }

                SpecPlayerElement specElement = Instantiate(prefabPlayer, transform).GetComponent<SpecPlayerElement>();
                specElement.Init(player.Key);

                listPlayer.Add(specElement);
            }
        }

        if(listPlayer.Count > 0)
        {
            listPlayer[0].SpecPlayer();
        }
    }
}
