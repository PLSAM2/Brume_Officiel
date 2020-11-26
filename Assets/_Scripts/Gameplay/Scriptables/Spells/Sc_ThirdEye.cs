using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewThirdEyeSpell", menuName = "CreateCuston/NewSpell/ThirdEye")]
public class Sc_ThirdEye : Sc_Spell
{
    [Header("AutoParameters")]
    [TabGroup("ThirdEye Parameters")] public ThirdEyeParameters parameters;
}


[System.Serializable]
public class ThirdEyeParameters
{
    public float fowRaduis = 4;

    public float waveRange = 15;
    public float waveDuration = 0.3f;

    public float cursedDuration = 3;

    public float echoRange = 8;
    public float echoDuration = 10;

    public AnimationCurve waveCurve;

    public AudioClip waveAudio;
}
