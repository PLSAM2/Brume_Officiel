using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/BaseSpell")]
public class Sc_Spell : ScriptableObject
{
    public float canalisationTime, movementModifier, range, cooldown;
    public En_CharacterState forbiddenState = En_CharacterState.Canalysing | En_CharacterState.Stunned;
    public bool canCancel;
    [InfoBox("Utilise la position de la souris au moment de l'input et pas de la réalisation du sort")] public bool useLastRecordedMousePos;
    public Sprite spellIcon;
    public int numberOfCharge;

    public DamagesParameters damagesToDeal;
}