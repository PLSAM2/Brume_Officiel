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

    [HideInInspector] public PlayerModule myPlayerModule;
	[Header("Spell Icons")]
	public IconUi firstSpell;
	public IconUi secondSpell, thirdSpell, sprintIcon, autoAttackIcon, wardIcon;

    public TextMeshProUGUI timer;
    public TextMeshProUGUI allyScore;
    public TextMeshProUGUI ennemyScore;

    public TextMeshProUGUI generalMessage;
    public TextMeshProUGUI generalPoints;
    public Animator generalMessageAnim;
    public Animator generalPointsAnim;

    [SerializeField] Image brumeFilter;

	[Header("Status Icon")]
	public Image stunIcon;
	public Image slowIcon, spedUpIcon, silencedIcon,canalysingIcon;


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
            case En_SpellInput.Ward:
                wardIcon.UpdateFillAmount(_time, _completeCd);
                CheckBeReady(_time, wardIcon, 0.05f);
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
            case En_SpellInput.Ward:
                wardIcon.SetSprite(_spellAttached.spellIcon);
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
            case En_SpellInput.Ward:
                wardIcon.UpdatesChargesAmont(_charges);
                break;

        }
	}

	public void StatusUpdate(En_CharacterState _currentState)
	{
		if ((_currentState & En_CharacterState.Silenced) != 0)
			silencedIcon.gameObject.SetActive(true);
		else
			silencedIcon.gameObject.SetActive(false);

		if ((_currentState & En_CharacterState.Slowed) != 0)
			slowIcon.gameObject.SetActive(true);
		else
			slowIcon.gameObject.SetActive(false);

		if ((_currentState & En_CharacterState.SpedUp)!= 0)
			spedUpIcon.gameObject.SetActive(true);
		else
			spedUpIcon.gameObject.SetActive(false);

		if ((_currentState & En_CharacterState.Stunned)!= 0)
			stunIcon.gameObject.SetActive(true);
		else
			stunIcon.gameObject.SetActive(false);

		if ((_currentState & En_CharacterState.Canalysing) != 0)
			canalysingIcon.gameObject.SetActive(true);
		else
			canalysingIcon.gameObject.SetActive(false);
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
