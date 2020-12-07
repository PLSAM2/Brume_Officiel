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

        NetworkManager.Instance.OnPlayerQuit += OnPlayerDeconnect;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerRespawn -= OnPlayerRespawn;

        NetworkManager.Instance.OnPlayerQuit -= OnPlayerDeconnect;
    }

    void OnPlayerDeconnect (PlayerData player)
    {
        //if (RoomManager.Instance.GetPlayerData(player.ID).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        //{
        //    RefreshList();

        //    if (playerSpected == player.ID)
        //    {
        //        TryToSpec();
        //    }
        //}
    }

    void OnPlayerDie(ushort playerId, ushort killerId)
    {
        if (playerId == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            isSpec = true;
            CameraManager.Instance.isSpectate = true;

            UiManager.Instance.SetAlphaBrume(0);

            RefreshList();
            TryToSpec();
            return;
        }

        if(RoomManager.Instance.GetPlayerData(playerId).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        {
            RefreshList();
            ChangeSpecPlayer(playerSpected);
        }
    }

    void OnPlayerRespawn(ushort playerId)
    {
        if (playerId == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            isSpec = false;
            CameraManager.Instance.ResetPlayerFollow();
            SuprrOld();
            return;
        }

        if (RoomManager.Instance.GetPlayerData(playerId).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam && isSpec)
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
            if (player.Value == GameManager.Instance.currentLocalPlayer) { continue; }

            if (RoomManager.Instance.GetPlayerData(player.Key).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam) {

                SpecPlayerElement specElement = Instantiate(prefabPlayer, parentList).GetComponent<SpecPlayerElement>();
                specElement.Init(player.Key, this);

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

    public void ChangeSpecPlayer(ushort id)
    {
        playerSpected = id;
        CameraManager.Instance.SetFollowObj(GameManager.Instance.networkPlayers[id].transform);

        foreach (SpecPlayerElement player in listPlayer)
        {
            player.eye.SetActive(player.playerId == id);
        }
    }
}
