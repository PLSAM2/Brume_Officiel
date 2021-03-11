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

        if(myId == _playerDie) { return; }

        string result = "<color=";
        if (RoomManager.Instance.GetPlayerData(_playerDie).playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            result += GameFactory.GetColorTeamInHex(Team.red) + ">";
            AudioManager.Instance.Play2DAudio(allyEliminated);
        }
        else
        {
            result += GameFactory.GetColorTeamInHex(Team.blue) + ">";
            AudioManager.Instance.Play2DAudio(enemyElimated);
        }

        result += RoomManager.Instance.GetPlayerData(_playerDie).playerCharacter.ToString();
        UiManager.Instance.myAnnoncement.ShowAnnoncement(result + " HAS BEEN KILLED</color>");


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

    public void AltarEndAnnoncement(string _value, Altar _altar)
    {
        text.text = _value;
        myAnimator.SetTrigger("Show");

        waypointObj.SetImageColor(altarEndColor);

        waypointObj.target = _altar.transform;

        waypointObj.gameObject.SetActive(true);
        waypointObj.ActiveAnnonciation(iconPos);

        currentAltar = _altar;
    }

    public void NewAltarAnnoncement(string _value, Altar _altar) {
        text.text = _value;
        myAnimator.SetTrigger("Show");

        waypointObj.target = _altar.transform;

        waypointObj.gameObject.SetActive(true);
        waypointObj.ActiveAnnonciation(iconPos);


        currentAltar = _altar;
    }

    public void ShowAnnoncement(string _value)
    {
        text.text = _value;
        myAnimator.SetTrigger("Show");
    }
}
