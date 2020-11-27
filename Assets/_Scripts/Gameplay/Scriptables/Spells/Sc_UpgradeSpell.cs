using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector; 

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/UpgradeSpell")]
public class Sc_UpgradeSpell : Sc_Spell
{
    [Header("Duration")]
    [TabGroup("Upgrade Parameters")] [Header("DurationOfTheUpgradedSpell")] public float duration = 10;

    [Header("ThrowBack")]
    [TabGroup("Upgrade Parameters")] public Sc_Status statusThrowback;
}
