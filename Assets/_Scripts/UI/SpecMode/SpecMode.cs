using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpecMode : MonoBehaviour
{
    List<SpecPlayerElement> listPlayer = new List<SpecPlayerElement>();

    [SerializeField] GameObject prefabPlayer;
    [SerializeField] Transform parentList;

    [SerializeField] GameObject label;

    bool isSpec = false;
    public ushort playerSpected;

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
        GameManager.Instance.OnPlayerRespawn += OnPlayerRespawn;

        GameManager.Instance.OnPlayerDisconnect += OnPlayerDeconnect;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerRespawn -= OnPlayerRespawn;

        GameManager.Instance.OnPlayerDisconnect -= OnPlayerDeconnect;
    }

    void OnPlayerDeconnect (ushort playerId)
    {
        if (RoomManager.Instance.GetPlayerData(playerId).playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        {
            RefreshList();

            if (playerSpected == playerId)
            {
                TryToSpec();
            }
        }
    }

    void OnPlayerDie(ushort playerId, ushort killerId)
    {
        if (playerId == RoomManager.Instance.GetLocalPlayer().ID)
        {
            isSpec = true;
            CameraManager.Instance.isSpectate = true;

            RefreshList();
            TryToSpec();
            return;
        }

        if(RoomManager.Instance.GetPlayerData(playerId).playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        {
            RefreshList();
            SpecPlayer(playerSpected);
        }
    }

    void OnPlayerRespawn(ushort playerId)
    {
        if (playerId == RoomManager.Instance.GetLocalPlayer().ID)
        {
            isSpec = false;
            CameraManager.Instance.ResetPlayerFollow();
            SuprrOld();
            return;
        }

        if (RoomManager.Instance.GetPlayerData(playerId).playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        {
            RefreshList();
            
            if(playerSpected == playerId)
            {
                TryToSpec();
            }
        }
    }

    void SuprrOld()
    {
        foreach (SpecPlayerElement oldPlayer in listPlayer)
        {
            Destroy(oldPlayer.gameObject);
        }

        label.SetActive(false);
    }

    void RefreshList()
    {
        SuprrOld();

        label.SetActive(true);

        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if(RoomManager.Instance.GetPlayerData(player.Key).playerTeam == RoomManager.Instance.GetLocalPlayer().playerTeam) {

                if(player.Value == GameManager.Instance.currentLocalPlayer) { continue; }

                SpecPlayerElement specElement = Instantiate(prefabPlayer, parentList).GetComponent<SpecPlayerElement>();
                specElement.Init(player.Key);

                listPlayer.Add(specElement);
            }
        }
    }

    void TryToSpec()
    {
        foreach (SpecPlayerElement player in listPlayer)
        {
            player.SpecPlayer();
            playerSpected = player.playerId;
            CameraManager.Instance.SetFollowObj(GameManager.Instance.networkPlayers[player.playerId].transform);
            return;
        }
    }

    void SpecPlayer(ushort id)
    {
        foreach (SpecPlayerElement player in listPlayer)
        {
            if(player.playerId == id)
            {
                player.SpecPlayer();
                playerSpected = player.playerId;
            }
        }
    }
}
