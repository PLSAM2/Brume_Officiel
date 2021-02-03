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
    public float durationOfTheAoe, timeBeforeFinalDisparition;
    public DamagesInfos damagesToDealOnImpact, damagesToDealOnDuration, finalDamages;
    public DamagesInfos imptactAlly, durationAlly, finalAlly;
    public bool useOwnerPos=false;
    [Tooltip("De base c est une sphère")] public bool isBox;
    [HideIf("isBox")] public float aoeRadius;
    [ShowIf("isBox")] public Vector3 boxDimension;
}

