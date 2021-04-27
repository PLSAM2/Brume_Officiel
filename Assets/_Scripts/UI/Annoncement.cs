using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using static GameData;

public class Annoncement : MonoBehaviour
{
    [SerializeField] Animator myAnimator;
    [SerializeField] TextMeshProUGUI text;
    [SerializeField] RectTransform iconPos;

    [SerializeField] AudioClip allyEliminated, enemyElimated, altarsAnnonced;

    public bool IsAnnoncing = false;

    List<bufferedInfo> currentBufferedAnnonce = new List<bufferedInfo>();

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
        GameManager.Instance.OnAllCharacterSpawned += OnAllPlayerSpawn;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
        GameManager.Instance.OnAllCharacterSpawned -= OnAllPlayerSpawn;
    }

    void OnAllPlayerSpawn()
    {
        List<Waypoint> allWaypoint = new List<Waypoint>();
        foreach (Altar a in GameManager.Instance.allAltar)
        {
            allWaypoint.Add(a.waypointObj);
        }

        NewAltarAnnoncement(("ALTARS AWAKENS").ToUpper(), allWaypoint, altarsAnnonced, null);
        StatManager.Instance.AddAltarEvent(altarEvent.state.AWAKENS, "ALTARS AWAKENS");
    }

    void OnPlayerDie(ushort _playerDie, ushort _killer)
    {
        ushort myId = NetworkManager.Instance.GetLocalPlayer().ID;

        AudioClip voice = allyEliminated;

        string result = "<color=";
        if (RoomManager.Instance.GetPlayerData(_playerDie).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            result += GameFactory.GetColorTeamInHex(Team.red) + ">";
        }
        else
        {
            result += GameFactory.GetColorTeamInHex(Team.blue) + ">";
            voice = enemyElimated;
        }
        result += RoomManager.Instance.GetPlayerData(_playerDie).playerCharacter.ToString();

        if (_killer == myId)
		{
            //play son kill todo
            ShowAnnoncement(("YOU HAVE SLAIN " + result).ToUpper(), null, enemyElimated);
        }
        else
        {
            ShowAnnoncement((result + " HAS BEEN KILLED</color>").ToUpper(), null, voice);
        }
    }

    public void NewAltarAnnoncement(string _value, List<Waypoint> _waypoints, AudioClip sfx = null, AudioClip voice = null) {

        if (!IsAnnoncing)
        {
            IsAnnoncing = true;

            text.text = _value;
            myAnimator.SetTrigger("Show");

            foreach(Waypoint w in _waypoints)
            {
                w.gameObject.SetActive(true);
                w.ActiveAnnonciation(iconPos);
            }

            PlaySound(sfx, voice);
        }
        else
        {
            bufferedInfo newAnnonce = new bufferedInfo();
            newAnnonce.textValue = _value;
            newAnnonce.isAlarAnnnonce = true;
            newAnnonce.waypoints = _waypoints;
            newAnnonce.sfx = sfx;
            newAnnonce.voice = voice;

            currentBufferedAnnonce.Add(newAnnonce);
        }
    }

    public void ShowAnnoncement(string _value, AudioClip sfx = null, AudioClip voice = null)
    {
        if (!IsAnnoncing)
        {
            IsAnnoncing = true;

            text.text = _value;
            myAnimator.SetTrigger("Show");

            PlaySound(sfx, voice);
        }
        else
        {
            bufferedInfo newAnnonce = new bufferedInfo();
            newAnnonce.textValue = _value;
            newAnnonce.sfx = sfx;
            newAnnonce.voice = voice;
            newAnnonce.isAlarAnnnonce = false;

            currentBufferedAnnonce.Add(newAnnonce);
        }
    }

    void PlaySound(AudioClip sfx = null, AudioClip voice = null)
    {
        if (sfx != null)
        {
            AudioManager.Instance.Play2DAudio(sfx);
        }

        if (voice != null)
        {
            AudioManager.Instance.Play2DAudio(voice);
        }
    }

    public void OnEndAnnoncement()
    {
        IsAnnoncing = false;
        if(currentBufferedAnnonce.Count > 0)
        {
            DisplayBufferedAnnonce();
        }
    }

    void DisplayBufferedAnnonce() {

        bufferedInfo currentAnnonce = currentBufferedAnnonce[0];

        if(!currentAnnonce.isAlarAnnnonce)
        {
            ShowAnnoncement(currentAnnonce.textValue, currentAnnonce.sfx, currentAnnonce.voice);
        }
        else
        {
            NewAltarAnnoncement(currentAnnonce.textValue, currentAnnonce.waypoints, currentAnnonce.sfx, currentAnnonce.voice);
        }

        currentBufferedAnnonce.RemoveAt(0);
    }

    public struct bufferedInfo
    {
        public string textValue;
        public bool isAlarAnnnonce;
        public List<Waypoint> waypoints;
        public AudioClip sfx;
        public AudioClip voice;
    }
}
