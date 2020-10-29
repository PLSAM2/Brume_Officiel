using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/UpgradeSpell")]
public class Sc_UpgradeSpell : Sc_Spell
{
    [Header("Duration")]
    public float duration = 10;

    [Header("Movement Bonus")][Tooltip("negative = slow, positive = bonus. valeur du perso 1 +bonusPercentageMoveSpeed * movespeed ")]
     public float bonusPercentageMoveSpeed = .3f;

    [Header("DashUpgrade")]
    public int numberOfChargeAdded =1;

    [Header("AutoUpgrade")]
    public float durationAdded= .3f;
    public int shotAdded= 2;

    [Header("ThrowBack")]
    public float durationSilenced;
    public En_CharacterState stateThrowbackToApply;
}
