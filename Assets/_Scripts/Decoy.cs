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

    public Sc_CharacterParameters reParameter;

    public FootstepAudio myFootStep;

    public NetworkedObject netObj;

    public CharacterController charac;

    Quaternion uiRotation;

    private void Awake()
    {
        uiRotation = myUI.transform.rotation;
    }

    private void OnEnable ()
	{
        netObj.OnSpawnObj += Init;
    }

    public void Init()
    {
        PlayerData _tempData = netObj.GetOwner();
        myTeam = _tempData.playerTeam;


        myFootStep.isDecoy = true;
        myFootStep.myDecoy = this;

        myUI.Init(myTeam, _tempData.Name, GameManager.Instance.networkPlayers[_tempData.ID].liveHealth, reParameter.maxHealth);
    }

    void Update()
    {
        charac.Move(transform.forward * reParameter.movementParameters.movementSpeed * Time.deltaTime);
        myAnimator.SetBool("IsMoving", true);
    }

    private void LateUpdate()
    {
        myUI.transform.rotation = uiRotation;
    }

    public void DealDamages(DamagesInfos _damagesToDeal, Transform _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1)
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
