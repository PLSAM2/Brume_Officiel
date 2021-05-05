using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Decoy : MonoBehaviour
{
    public UIDecoy myUI;

    public float lifeTime = 6;

    public Animator myAnimator;

    public Team myTeam;
    public ushort idPlayer;
    PlayerData myPlayerData;

    public Sc_CharacterParameters reParameter;

    public FootstepAudio myFootStep;

    public void Start()
    {
        myAnimator.SetBool("IsMoving", true); 
    }

    public void Init(Team _team)
    {
        Team myTeam = _team;

        idPlayer = (ushort) GameFactory.GetPlayerCharacterInTeam(_team, Character.Re);
        myPlayerData = RoomManager.Instance.GetPlayerData(idPlayer);

        myFootStep.isDecoy = true;
        myFootStep.myDecoy = this;

        myUI.Init(_team, myPlayerData.Name, GameManager.Instance.networkPlayers[idPlayer].liveHealth, reParameter.maxHealth);
    }
}
