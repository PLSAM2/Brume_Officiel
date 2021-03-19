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

    [SerializeField] GameObject waypointAltarPrefab;
    Waypoint waypointObj;
    Altar currentAltar;

    [SerializeField] Color altarLockColor;
    [SerializeField] Color altarUnlockColor;
    [SerializeField] Color altarEndColor;

    [SerializeField] AudioClip allyEliminated, enemyElimated;

    public bool IsAnnoncing = false;

    List<bufferedInfo> currentBufferedAnnonce = new List<bufferedInfo>();

    private void Start()
    {
        waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<Waypoint>();
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
    }

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
    }

    private void Update()
    {
        //TODO afficher timer altar
        if(currentAltar != null)
        {
            float currentTimeLeft = currentAltar.unlockTime - (Time.fixedTime - currentAltar.currentTime);
            if(currentTimeLeft > 0)
            {
                waypointObj.SetUnderText(Mathf.RoundToInt(currentTimeLeft) + "s");
            }
            else
            {
                waypointObj.SetUnderText("");
            }
        }
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

    public void SetUnlockAltar()
    {
        waypointObj.SetImageColor(altarUnlockColor);
    }

    public void DisableAltar()
    {
        waypointObj.SetImageColor(altarLockColor);
        waypointObj.gameObject.SetActive(false);
    }

    public void AltarEndAnnoncement(string _value, Altar _altar, AudioClip sfx = null, AudioClip voice = null)
    {
        if (!IsAnnoncing)
        {
            IsAnnoncing = true;

            waypointObj.SetImageColor(altarEndColor);

            text.text = _value;
            myAnimator.SetTrigger("Show");

            waypointObj.target = _altar.transform;

            waypointObj.gameObject.SetActive(true);
            waypointObj.ActiveAnnonciation(iconPos);

            currentAltar = _altar;

            PlaySound(sfx, voice);
        }
        else
        {
            bufferedInfo newAnnonce = new bufferedInfo();
            newAnnonce.textValue = _value;
            newAnnonce.myAltar = _altar;
            newAnnonce.isEnd = true;
            newAnnonce.sfx = sfx;
            newAnnonce.voice = voice;

            currentBufferedAnnonce.Add(newAnnonce);
        }
    }

    public void NewAltarAnnoncement(string _value, Altar _altar, AudioClip sfx = null, AudioClip voice = null) {
        if (!IsAnnoncing)
        {
            IsAnnoncing = true;

            text.text = _value;
            myAnimator.SetTrigger("Show");

            waypointObj.target = _altar.transform;

            waypointObj.gameObject.SetActive(true);
            waypointObj.ActiveAnnonciation(iconPos);

            currentAltar = _altar;

            PlaySound(sfx, voice);
        }
        else
        {
            bufferedInfo newAnnonce = new bufferedInfo();
            newAnnonce.textValue = _value;
            newAnnonce.myAltar = _altar;
            newAnnonce.isEnd = false;
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

        if(currentAnnonce.myAltar == null)
        {
            ShowAnnoncement(currentAnnonce.textValue, currentAnnonce.sfx, currentAnnonce.voice);
        }
        else
        {
            if (currentAnnonce.isEnd == false)
            {
                NewAltarAnnoncement(currentAnnonce.textValue, currentAnnonce.myAltar, currentAnnonce.sfx, currentAnnonce.voice);
            }
            else
            {
                AltarEndAnnoncement(currentAnnonce.textValue, currentAnnonce.myAltar, currentAnnonce.sfx, currentAnnonce.voice);
            }
        }

        currentBufferedAnnonce.RemoveAt(0);
    }

    public struct bufferedInfo
    {
        public string textValue;
        public Altar myAltar;
        public bool isEnd;
        public AudioClip sfx;
        public AudioClip voice;
    }
}
