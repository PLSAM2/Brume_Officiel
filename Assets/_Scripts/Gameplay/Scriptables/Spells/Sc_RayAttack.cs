using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
[InlineEditor]
[CreateAssetMenu(fileName = "newRayAttack", menuName = "CreateCuston/newRayAttack")]
public class Sc_RayAttack : Sc_Spell
{
    [TabGroup("DamagePart")] public DamagesInfos damagesToDeal;
}
