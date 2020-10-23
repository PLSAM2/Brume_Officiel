using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class UiManager : MonoBehaviour
{
    private static UiManager _instance;
    public static UiManager Instance { get { return _instance; } }

    public PlayerModule myPlayerModule;
    public IconUi firstSpell, secondSpell, thirdSpell, sprintIcon, autoAttackIcon;

    public TextMeshProUGUI timer;
    public TextMeshProUGUI allyScore;
    public TextMeshProUGUI ennemyScore;

    public TextMeshProUGUI generalMessage;
    public TextMeshProUGUI generalPoints;
    public Animator generalMessageAnim;
    public Animator generalPointsAnim;

    [SerializeField] Image brumeFilter;

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    private void Start()
    {
        // A changer >>
        Team team = RoomManager.Instance.GetLocalPlayer().playerTeam;

        if (team == Team.blue)
        {
            allyScore.color = Color.blue;
            ennemyScore.color = Color.red;
        }
        else if (team == Team.red)
        {
            allyScore.color = Color.red;
            ennemyScore.color = Color.blue;
        }

        // <<
    }

    public void UpdateUiCooldownSpell(En_SpellInput spell, float _time, float _completeCd)
    {

        switch (spell)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, firstSpell, .2f);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, secondSpell, .2f);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, thirdSpell, .2f);
                break;

            case En_SpellInput.Maj:
                sprintIcon.UpdateFillAmount( _time, _completeCd);
                break;

            case En_SpellInput.Click:
                autoAttackIcon.UpdateFillAmount( _time, _completeCd);
                CheckBeReady(_time, autoAttackIcon, 0.05f);
                break;
        }
    }

    public void SetupIcon(Sc_Spell _spellAttached, En_SpellInput _input)
    {
        switch (_input)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.SetSprite(_spellAttached.spellIcon);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.SetSprite(_spellAttached.spellIcon);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.SetSprite(_spellAttached.spellIcon);
                break;

            case En_SpellInput.Maj:
                break;

            case En_SpellInput.Click:
                autoAttackIcon.SetSprite(_spellAttached.spellIcon);
                break;
        }
    }

    void CheckBeReady(float _actualTime, IconUi _iconToPrep, float _timeToCheckShow)
    {
        if (_actualTime <= 0.2f)
            _iconToPrep.BeReady(true, _timeToCheckShow);
        else
            _iconToPrep.BeReady(false, _timeToCheckShow);
    }

    public void UpdateChargesUi(int _charges, En_SpellInput _spellInput)
	{
        switch(_spellInput)
		{
            case En_SpellInput.FirstSpell:
                firstSpell.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.SecondSpell:
                secondSpell.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.ThirdSpell:
                thirdSpell.UpdatesChargesAmont(_charges);
                break;
            case En_SpellInput.Click:
                autoAttackIcon.UpdatesChargesAmont(_charges);
                break;

        }
	}

    public void SetAlphaBrume(float value)
    {
        brumeFilter.color = new Color(brumeFilter.color.r, brumeFilter.color.g, brumeFilter.color.b, value);
    }


    public void DisplayGeneralMessage(string value)
    {
        generalMessage.text = value;
        generalMessageAnim.Play("GenMessage");
    }

    public void DisplayGeneralPoints(Team team, int value)
    {
        generalPoints.text = "+" + value;

        if (team == Team.blue)
        {
            generalPoints.color = Color.blue;
        }
        else if (team == Team.red)
        {
            generalPoints.color = Color.red;
        }

        generalPointsAnim.Play("GenPoints");
    }
}
