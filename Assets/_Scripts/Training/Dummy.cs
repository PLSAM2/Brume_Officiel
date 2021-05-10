using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dummy : MonoBehaviour, Damageable
{
    public MovementModule movementPart;
    private ushort _liveHealth;
    public UIPlayerManager myUiPlayerManager;
    public Sc_CharacterParameters characterParameters;


    [HideInInspector] public Action<Dummy> OnHit;
    [HideInInspector] public Action<Dummy> OnKilled;
    public ushort liveHealth
    {
        get => _liveHealth; set
        {
            _liveHealth = value;
            myUiPlayerManager.UpdateLife();
        }
    }

    private void Start()
    {
        liveHealth = characterParameters.maxHealth;
    }


    /// <summary>
    /// Deal damage to this character
    /// </summary>
    /// <param name="ignoreTickStatus"> Must have ignoreStatusAndEffect false to work</param>
    public void DealDamages(DamagesInfos _damagesToDeal, Transform _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1)
    {

        if (InGameNetworkReceiver.Instance.GetEndGame())
        {
            return;
        }

        DealDamagesLocaly(_damagesToDeal.damageHealth, dealerID);

        //if ((state & _damagesToDeal.stateNeeded) != 0)
        //{
        //	// SEND STATUS

        //	if (_damagesToDeal.additionalMovementToApply != null)
        //	{
        //		SendForcedMovement(_damagesToDeal.additionalMovementToApply.MovementToApply(transform.position, _positionOfTheDealer));
        //	}

        //	if (_damagesToDeal.damageHealth > 0)
        //	{
        //		using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        //		{
        //			_writer.Write(myPlayerId);
        //			_writer.Write(_damagesToDeal.additionalDamages);
        //			using (Message _message = Message.Create(Tags.Damages, _writer))
        //			{
        //				currentClient.SendMessage(_message, SendMode.Reliable);
        //			}
        //		}
        //	}
        //}

        if (_damagesToDeal.movementToApply != null)
        {
            movementPart.AddDash(_damagesToDeal.movementToApply.MovementToApply(transform.position, _positionOfTheDealer.position, _percentageOfTheMovement));
        }
    }

    public void DealDamagesLocaly(ushort damages, ushort? dealerID = null)
    {
        if (InGameNetworkReceiver.Instance.GetEndGame())
        {
            return;
        }

        //SI JE NE CONTRE PAS ouayant un etat d invulnérabilité

        OnHit?.Invoke(this);
        if (damages > 0)
        {
            LocalPoolManager.Instance.SpawnNewImpactDamageFX(
                transform.position + Vector3.up * 1,
                GameData.Team.red
            );
        }

        if ((int)liveHealth - (int)damages <= 0)
        {
            OnKilled?.Invoke(this);
            liveHealth = characterParameters.maxHealth;
        }
        else
        {
            int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)damages, 0, 1000);
            liveHealth = (ushort)_tempHp;
        }
    }

    /// <summary>
    /// DO NOT use this until YOU KNOW what you do :)
    /// </summary>
    public void ForceDealDamages(ushort dmg)
    {
        if ((int)liveHealth - (int)dmg <= 0)
        {
            liveHealth = 0;
        }
        else
        {
            int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)dmg, 0, 1000);
            liveHealth = (ushort)_tempHp;
        }
    }

    public void LocallyDivideHealth(ushort divider)
    {
        liveHealth = (ushort)Mathf.Round(liveHealth / divider);
    }

    public bool IsInMyTeam(GameData.Team _indexTested)
    {
        return false;
    }


    public void EventTutorial(DummyEvent dummyEvent)
    {
        switch (dummyEvent)
        {
            case DummyEvent.Hit:
                OnHit += TutorialManager.Instance.OnDummyHit;
                break;
            case DummyEvent.Kill:
                OnKilled += TutorialManager.Instance.OnDummyKilled;
                break;
            default:
                throw new Exception("not existing event");
        }
    }

}
