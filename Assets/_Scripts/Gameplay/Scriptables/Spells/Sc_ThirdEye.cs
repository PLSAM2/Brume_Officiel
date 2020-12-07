using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewThirdEyeSpell", menuName = "CreateCuston/NewSpell/ThirdEye")]
public class Sc_ThirdEye : Sc_Spell
{
    [Header("AutoParameters")]
    [TabGroup("ThirdEye Parameters")] public float fowRaduis = 4;

    [TabGroup("ThirdEye Parameters")] public float waveDuration = 0.3f; // ONDE DE CHOC SE DEPLOIE EN X SECOND ET SE FERME EN X SECOND

    [TabGroup("ThirdEye Parameters")] public float durationOfTheOutline = 3;// DUREE 1 ER ETAPE DU SORT

    [TabGroup("ThirdEye Parameters")] public AudioClip waveAudio;
}

