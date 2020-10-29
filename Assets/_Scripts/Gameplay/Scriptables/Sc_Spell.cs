using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/BaseSpell")]
public class Sc_Spell : ScriptableObject
{
    [Header("Properties")]
    public float canalisationTime;
      public float range, cooldown;
    public int numberOfCharge = 1;

    [Header("Constraints")]
    public En_CharacterState forbiddenState = En_CharacterState.Canalysing | En_CharacterState.Stunned | En_CharacterState.Silenced;

    [Header("Additional Rules")]
    public bool canCancel;
       public bool mustUseACollFreePos = false;
    [InfoBox("Utilise la position de la souris au moment de l'input et pas de la réalisation du sort")] public bool useLastRecordedMousePos;

    [Header("Ui")]
    public Sprite spellIcon;
}