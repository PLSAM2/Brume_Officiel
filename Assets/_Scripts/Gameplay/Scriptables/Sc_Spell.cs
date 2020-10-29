using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/BaseSpell")]
public class Sc_Spell : ScriptableObject
{
    public float canalisationTime,  range, cooldown;
    public En_CharacterState forbiddenState = En_CharacterState.Canalysing | En_CharacterState.Stunned | En_CharacterState.Silenced;
    public bool canCancel, mustUseACollFreePos = false;
    [InfoBox("Utilise la position de la souris au moment de l'input et pas de la réalisation du sort")] public bool useLastRecordedMousePos;
    public Sprite spellIcon;
    public int numberOfCharge = 1;
}