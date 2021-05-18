using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TutorialTriggerZone : MonoBehaviour
{
    public LayerMask characterLayer;

    public bool giveDamageToPlayer = false;
    [ShowIf("giveDamageToPlayer")] public bool oneTime = false;
    [ShowIf("giveDamageToPlayer")] public ushort damages = 1;

    private bool damageGiven = false;
    [HideInInspector] public Action<TutorialTriggerZone> OnEnter;
    [HideInInspector] public Action<TutorialTriggerZone> OnExit;



    private void OnDisable()
    {
        if (OnEnter != null)
            OnEnter -= TutorialManager.Instance.OnZoneEnter;
        if (OnExit != null)
            OnExit -= TutorialManager.Instance.OnZoneExit;
    }


    private void OnTriggerEnter(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, characterLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }
            if (!_pModule.mylocalPlayer.isOwner)
            {
                return;
            }

            if (giveDamageToPlayer)
            {
                if ((oneTime && damageGiven == false) || !oneTime)
                {
                    DamagesInfos dm = new DamagesInfos(damages);
                    _pModule.mylocalPlayer.DealDamages(dm, this.transform, null, true);
                    damageGiven = true;
                }
            }


            OnEnter?.Invoke(this);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, characterLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }
            if (!_pModule.mylocalPlayer.isOwner)
            {
                return;
            }

            OnExit?.Invoke(this);
        }
    }


    public void EventTutorial(ZoneEvent zoneEvent)
    {
        switch (zoneEvent)
        {
            case ZoneEvent.Entered:
                OnEnter += TutorialManager.Instance.OnZoneEnter;
                break;
            case ZoneEvent.Exit:
                OnExit += TutorialManager.Instance.OnZoneExit;
                break;
            default:
                throw new Exception("not existing event");
        }
    }

}
