using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/UpgradeSpell")]
public class Sc_UpgradeSpell : Sc_Spell
{
    [Header("Duration")]
    [Header("DurationOfTheUpgradedSpell")] public float duration = 10;

    [Header("ThrowBack")]
    public Sc_Status statusThrowback;
}
