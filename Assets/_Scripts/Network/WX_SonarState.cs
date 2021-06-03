using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WX_SonarState : MonoBehaviour
{
    [SerializeField] LocalPlayer myLocalPlayer;

    UnityClient currentClient;

    Dictionary<ushort, bool> enemyList = new Dictionary<ushort, bool>();

    wxSonarState myState = wxSonarState.None;

    [SerializeField] float timeDamageDisplay = 1;
    [SerializeField] float timeCD = 3;

    bool damagePlaying = false;
    bool viewPlaying = false;

    Coroutine yellowCoroutine;

    [SerializeField] AudioClip spotedSound;
    [SerializeField] AudioClip hitSound;

    private void OnEnable()
    {
        currentClient = NetworkManager.Instance.GetLocalClient();
        currentClient.MessageReceived += OnMessageReceive;

        myLocalPlayer.OnInitFinish += OnInitPlayer;
    }

    void OnInitPlayer()
    {
        if (myLocalPlayer.isOwner)
        {
           // GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;
            GameManager.Instance.OnPlayerDie += OnPlayerDie;

            foreach (KeyValuePair<ushort, PlayerData> player in RoomManager.Instance.actualRoom.playerList)
            {
                if (!myLocalPlayer.IsInMyTeam(player.Value.playerTeam))
                {
                    enemyList.Add(player.Key, false);
                }
            }
        }
        else
        {
            GameManager.Instance.OnPlayerGetDamage += OnPlayerGetDamage;
        }
    }

    private void OnDisable()
    {
        myLocalPlayer.OnInitFinish -= OnInitPlayer;

        if (myLocalPlayer.isOwner)
        {
            //GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
            GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        }
        else
        {
            GameManager.Instance.OnPlayerGetDamage -= OnPlayerGetDamage;
        }
        currentClient.MessageReceived -= OnMessageReceive;
    }

    private void OnMessageReceive(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.WXSonarState)
            {
                OnStateReceive(sender, e);
            }
        }
    }

    void OnStateReceive(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                myState = (wxSonarState)reader.ReadUInt16();
            }
        }
    }

    void OnPlayerDie(ushort id, ushort idKiller)
    {
        if (!myLocalPlayer.IsInMyTeam(RoomManager.Instance.GetPlayerData(id).playerTeam))
        {
            enemyList[id] = false;
            UpdateState();
        }
    }

    /*
    void OnPlayerViewChange(ushort id, bool value)
    {
        if (!myLocalPlayer.IsInMyTeam(RoomManager.Instance.GetPlayerData(id).playerTeam))
        {
            if (enemyList[id] != value)
            {
                enemyList[id] = value;
                UpdateState();
            }
        }
    }*/

    void UpdateState()
    {
        bool isInView = false;
        foreach(KeyValuePair<ushort, bool> enemy in enemyList)
        {
            if (enemy.Value)
            {
                isInView = true;
                break;
            }
        }

        if (isInView && myState != wxSonarState.InView)
        {
            SendState(wxSonarState.InView);
        }
        else if(!isInView && myState != wxSonarState.None)
        {
            SendState(wxSonarState.None);
        }
    }

    void SendState(wxSonarState state)
    {
        myState = state;
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write((ushort) state);

            using (Message _message = Message.Create(Tags.WXSonarState, _writer))
            {
                currentClient.SendMessage(_message, SendMode.Unreliable);
            }
        }
    }

    void OnPlayerGetDamage(ushort id, ushort damage, ushort dealer)
    {
        if(GameFactory.GetActualPlayerFollow() == null)
        {
            return;
        }

        if (RoomManager.Instance.GetPlayerData(GameFactory.GetActualPlayerFollow().myPlayerId).playerTeam != RoomManager.Instance.GetPlayerData(id).playerTeam)
        {
            return;
        }

        if (id == myLocalPlayer.myPlayerId)
        {
            viewPlaying = false;

            if (!damagePlaying)
            {
                if(yellowCoroutine != null)
                {
                    //StopCoroutine(yellowCoroutine);
                }

                StartCoroutine(WxTakeDamage());
            }
        }
    }

    /*
    private void Update()
    {
        if (myLocalPlayer.isOwner)
        {
            return;
        }

        LocalPlayer p = GameFactory.GetActualPlayerFollow();

        if (RoomManager.Instance.GetPlayerData(p.myPlayerId).playerCharacter == GameData.Character.WuXin)
        { return; }
        
        //ping jaune

        if (myState == wxSonarState.InView && !damagePlaying && !viewPlaying)
        {
            viewPlaying = true;
            yellowCoroutine = StartCoroutine(PingJaune());
        }
    }

    IEnumerator PingJaune()
    {
        LocalPlayer p = GameFactory.GetActualPlayerFollow();

        foreach (Image img in p.myUiPlayerManager.sonarImg)
        {
            img.color = new Color(p.myUiPlayerManager.wxInViewColor.r, p.myUiPlayerManager.wxInViewColor.g, p.myUiPlayerManager.wxInViewColor.b, img.color.a);
        }
        p.myUiPlayerManager.sonar.SetActive(true);

        AudioManager.Instance.Play2DAudio(spotedSound);

        yield return new WaitForSeconds(timeDamageDisplay);

        p.myUiPlayerManager.sonar.SetActive(false);

        yield return new WaitForSeconds(timeCD);

        viewPlaying = false;
    }*/

    IEnumerator WxTakeDamage()
    {
        LocalPlayer p = GameFactory.GetActualPlayerFollow();

        if(RoomManager.Instance.GetPlayerData(p.myPlayerId).playerCharacter == GameData.Character.WuXin)
        {
            yield break;
        }

        damagePlaying = true;

        AudioManager.Instance.Play2DAudio(hitSound);

        yield return new WaitForSeconds(timeDamageDisplay);


        yield return new WaitForSeconds(timeCD);
        damagePlaying = false;
    }

    public enum wxSonarState
    {
        None,
        InView
    }
}
