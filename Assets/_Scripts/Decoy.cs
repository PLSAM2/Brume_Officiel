using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Decoy : MonoBehaviour, Damageable
{
    public UIDecoy myUI;

    public float lifeTime = 6;

    public Animator myAnimator;

    public Team myTeam;
    public ushort idPlayer;
    PlayerData myPlayerData;

    public Sc_CharacterParameters reParameter;

    public FootstepAudio myFootStep;

    public NetworkedObject netObj;

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

    public void DealDamages(DamagesInfos _damagesToDeal, Vector3 _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1)
    {
        if(_damagesToDeal.damageHealth > 0)
        {
            //destroy
            //netObj
        }
    }

    public bool IsInMyTeam(Team _indexTested)
    {
        return _indexTested == myTeam;
    }
}
