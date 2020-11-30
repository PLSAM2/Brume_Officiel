using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "newAoe", menuName = "CreateCuston/NewAoeParameters")]
public class Sc_Aoe : ScriptableObject
{
    public AoeParameters rules;
}

[System.Serializable]
public class AoeParameters
{
    [Header("AoeParameters")]
    public float durationOfTheAoe, aoeRadius;
    public DamagesInfos damagesToDealOnImpact, damagesToDealOnDuration;
}
