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

	private void OnEnable ()
	{
        netObj.OnSpawnObj += Init;

    }

	public void Start()
    {
        myAnimator.SetBool("IsMoving", true); 
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
        transform.Translate(transform.forward * reParameter.movementParameters.movementSpeed); 
    }

    private void LateUpdate()
    {
        transform.rotation = Quaternion.identity;
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
