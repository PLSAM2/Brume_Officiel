using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell")]
public class Sc_Spell : ScriptableObject
{
    public float canalisationTime, movementModifier, range, cooldown;
    public En_CharacterState StateAutorised;
    public bool canCancel;
    [InfoBox("Utilise la position de la souris au moment de l'input et pas de la réalisation du sort")] public bool useLastRecordedMousePos;
    public Sprite spellIcon;
    public int numberOfCharge;

    public DamagesParameters damagesToDeal;
}