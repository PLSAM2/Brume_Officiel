using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName ="NewSpell", menuName = "CreateCuston/NewSpell")]
public class Sc_Spell : ScriptableObject
{
    public float canalisationTime, movementModifier, range, cooldown;
    public En_CharacterState StateAutorised;
    public bool canCancel;

    public Sprite spellIcon;
}
