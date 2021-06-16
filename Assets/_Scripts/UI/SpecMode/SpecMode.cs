using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class SpecMode : MonoBehaviour
{
    List<SpecPlayerElement> listPlayer = new List<SpecPlayerElement>();

    [SerializeField] GameObject prefabPlayer;
    [SerializeField] Transform parentList;

    [SerializeField] GameObject label;

    bool isSpec = false;
    public ushort playerSpected;

    [SerializeField] AudioClip deathAudio;

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
        GameManager.Instance.OnPlayerRespawn += OnPlayerRespawn;
        GameManager.Instance.OnSpecConnected += OnSpecConnected;

        NetworkManager.Instance.OnPlayerQuit += OnPlayerDeconnect;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnPlayerRespawn -= OnPlayerRespawn;
        GameManager.Instance.OnSpecConnected += OnSpecConnected;
        NetworkManager.Instance.OnPlayerQuit -= OnPlayerDeconnect;
    }

    void OnPlayerDeconnect(PlayerData player)
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

    void OnSpecConnected(ushort specId)
    {
        isSpec = true;
        CameraManager.Instance.isSpectate = true;

        SpectatorList();
        TryToSpec();
    }

    void OnPlayerDie(ushort playerId, ushort killerId)
    {
        if (playerId == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            isSpec = true;
            UiManager.Instance.spellUI.alpha = 0;

            GameManager.Instance.deadPostProcess.SetActive(true);

            if(deathAudio != null)
            {
                AudioManager.Instance.Play2DAudio(deathAudio);
            }

            CameraManager.Instance.isSpectate = true;

            StartCoroutine(WaitToDisplaySpecMode());
            return;
        }

        if (RoomManager.Instance.GetPlayerData(playerId).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        {
            RefreshList();

            if (playerSpected == playerId)
            {
                TryToSpec();
            }
            else
            {
                ChangeSpecPlayer(playerSpected);
            }
        }



        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == GameData.Team.spectator)
        {
            SpectatorList();

            if (playerId == playerSpected)
            {
                TryToSpec();
            }

        }


    }

    IEnumerator WaitToDisplaySpecMode()
    {
        yield return new WaitForSeconds(3);

        RefreshList();
        TryToSpec();
    }

    void OnPlayerRespawn(ushort playerId)
    {
        if (playerId == NetworkManager.Instance.GetLocalPlayer().ID)
        {
            GameManager.Instance.deadPostProcess.SetActive(false);
            isSpec = false;
            CameraManager.Instance.ResetPlayerFollow();
            SuprrOld();

            UiManager.Instance.spellUI.alpha = 1;
            return;
        }

        if (RoomManager.Instance.GetPlayerData(playerId).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam && isSpec)
        {
            RefreshList();

            if (playerSpected == playerId)
            {
                TryToSpec();
            }
        }


        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == GameData.Team.spectator)
        {
            SpectatorList();
        }

    }

    void SuprrOld()
    {
        foreach (SpecPlayerElement oldPlayer in listPlayer)
        {
            Destroy(oldPlayer.gameObject);
        }
        listPlayer.Clear();

        label.SetActive(false);
    }

    void RefreshList()
    {
        SuprrOld();

        label.SetActive(true);

        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (player.Value == GameManager.Instance.currentLocalPlayer) { continue; }

            if (RoomManager.Instance.GetPlayerData(player.Key).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
            {
                SpecPlayerElement specElement = Instantiate(prefabPlayer, parentList).GetComponent<SpecPlayerElement>();
                specElement.Init(player.Key, this);

                listPlayer.Add(specElement);
            }
        }
    }


    void SpectatorList()
    {
        SuprrOld();

        label.SetActive(true);

        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            SpecPlayerElement specElement = Instantiate(prefabPlayer, parentList).GetComponent<SpecPlayerElement>();
            specElement.Init(player.Key, this);

            listPlayer.Add(specElement);
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
        if (!GameManager.Instance.networkPlayers.ContainsKey(id)) { return; }

        foreach (GameObject obj in GameManager.Instance.networkPlayers[id].objToHide)
        {
            obj.SetActive(true);
        }

        if (GameManager.Instance.networkPlayers.ContainsKey(playerSpected))
        {
            PlayerModule p1 = GameManager.Instance.networkPlayers[playerSpected].myPlayerModule;
            PlayerModule p2 = GameManager.Instance.networkPlayers[id].myPlayerModule;

            if (p1.isInBrume != p2.isInBrume)
            {
                if (p1.isInBrume)
                {
                    GameFactory.GetBrumeById(p1.brumeId).ShowHideMesh(p1, true);
                }
            }
            else
            {
                if (p1.brumeId != p2.brumeId)
                {
                    GameFactory.GetBrumeById(p1.brumeId).ShowHideMesh(p1, true);
                }
            }
        }

        playerSpected = id;

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
        {
            CameraManager.Instance.CameraTravelingToSpecPLayer(id, GameManager.Instance.networkPlayers[id].transform);
        } else
        {
            CameraManager.Instance.SetFollowObj(GameManager.Instance.networkPlayers[id].transform);
        }


        foreach (SpecPlayerElement player in listPlayer)
        {
            player.eye.SetActive(player.playerId == id);
        }

        if (GameManager.Instance.networkPlayers[id].myPlayerModule.isInBrume)
        {
            GameFactory.GetBrumeById(GameManager.Instance.networkPlayers[id].myPlayerModule.brumeId).ForceEnter(GameManager.Instance.networkPlayers[id].myPlayerModule);
        }


        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator) // IF spectator
        {
            foreach(KeyValuePair<ushort, LocalPlayer> p in GameManager.Instance.networkPlayers)
            {
                if(p.Value != null)
                {
                    foreach (Ward w in GameManager.Instance.allWard)
                    {
                        if (w.myTeam == RoomManager.Instance.GetPlayerData(id).playerTeam)
                        {
                            w.GetMesh().SetActive(true);
                            w.GetFow().gameObject.SetActive(true);
                        }  else
                        {
                            w.GetMesh().SetActive(false);
                            w.GetFow().gameObject.SetActive(false);
                        }
                    }

                    p.Value.myFow.gameObject.SetActive(RoomManager.Instance.GetPlayerData(p.Key).playerTeam == RoomManager.Instance.GetPlayerData(id).playerTeam);
                }
            }
        }
    }
}
