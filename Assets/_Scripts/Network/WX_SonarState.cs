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
            GameManager.Instance.OnPlayerAtViewChange += OnPlayerViewChange;

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
            GameManager.Instance.OnPlayerAtViewChange -= OnPlayerViewChange;
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

    void OnPlayerViewChange(ushort id, bool value)
    {
        if (!myLocalPlayer.IsInMyTeam(RoomManager.Instance.GetPlayerData(id).playerTeam))
        {
            if (enemyList[id] != value)
            {
                print(value);
                enemyList[id] = value;
                UpdateState();
            }
        }
    }

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

        print(isInView);

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

    void OnStateReceive(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                wxSonarState state = (wxSonarState) reader.ReadUInt16();
                print(state);
                OnStateChangeUpdate(state);
            }
        }
    }

    void OnStateChangeUpdate(wxSonarState state)
    {
        LocalPlayer p = GameFactory.GetActualPlayerFollow();
        myState = state;

        if (RoomManager.Instance.GetPlayerData(p.myPlayerId).playerCharacter == GameData.Character.WuXin || state == wxSonarState.None)
        {
            p.myUiPlayerManager.sonar.SetActive(false);
            return;
        }

        foreach (Image img in p.myUiPlayerManager.sonarImg)
        {
            img.color = new Color(p.myUiPlayerManager.wxInViewColor.r, p.myUiPlayerManager.wxInViewColor.g, p.myUiPlayerManager.wxInViewColor.b, img.color.a);
        }
        p.myUiPlayerManager.sonar.SetActive(true);
    }

    void OnPlayerGetDamage(ushort id, ushort damage)
    {
        if(id == myLocalPlayer.myPlayerId)
        {
            StartCoroutine(WxTakeDamage());
        }
    }

    IEnumerator WxTakeDamage()
    {
        LocalPlayer p = GameFactory.GetActualPlayerFollow();

        if(RoomManager.Instance.GetPlayerData(p.myPlayerId).playerCharacter == GameData.Character.WuXin)
        {
            p.myUiPlayerManager.sonar.SetActive(false);
            yield break;
        }

        foreach(Image img in p.myUiPlayerManager.sonarImg)
        {
            img.color = new Color(p.myUiPlayerManager.wxTakeDamageColor.r, p.myUiPlayerManager.wxTakeDamageColor.g, p.myUiPlayerManager.wxTakeDamageColor.b, img.color.a);
        }
        p.myUiPlayerManager.sonar.SetActive(true);

        yield return new WaitForSeconds(timeDamageDisplay);

        OnStateChangeUpdate(myState);
    }

    public enum wxSonarState
    {
        None,
        InView
    }
}
