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

    public bool regenOnDeath = true;
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
        myUiPlayerManager.Init();
    }



    private void OnDisable()
    {
        if (OnHit != null)
            OnHit -= TutorialManager.Instance.OnDummyHit;
        if (OnKilled != null)
            OnKilled -= TutorialManager.Instance.OnDummyKilled;
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

        AudioManager.Instance.PlayHitAudio();



        DealDamagesLocaly(_damagesToDeal.damageHealth, dealerID);

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
            if (regenOnDeath)
            {
                liveHealth = characterParameters.maxHealth;
            } else
            {
                this.gameObject.SetActive(false);
            }

        }
        else
        {
            int _tempHp = (int)Mathf.Clamp((int)liveHealth - (int)damages, 0, 1000);
            liveHealth = (ushort)_tempHp;
        }
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
