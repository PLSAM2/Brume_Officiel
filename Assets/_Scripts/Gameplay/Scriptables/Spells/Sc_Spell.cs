﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/BaseSpell")]
public class Sc_Spell : ScriptableObject
{
	[Header("General Properties")]
	[TabGroup("Generic SpellParameters")] public float range;
	[TabGroup("Generic SpellParameters")] public float cooldown;
	[TabGroup("Generic SpellParameters")] public int numberOfCharge = 1;
	[TabGroup("Generic SpellParameters")] public En_CharacterState forbiddenState = En_CharacterState.Canalysing | En_CharacterState.Silenced;

	[Header("StartCanalisation")]
	[TabGroup("Generic SpellParameters")] public bool lockRotOnCanalisation = true;
	[TabGroup("Generic SpellParameters")] public bool lockPosOnCanalisation = false;
	[TabGroup("Generic SpellParameters")] public float canalisationTime;
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusToApplyOnCanalisation = new List<Sc_Status>();

	[Header("Anonciation")]
	[TabGroup("Generic SpellParameters")] public bool lockRotOnAnonciation = true;
	[TabGroup("Generic SpellParameters")] public bool LockPosOnAnonciation = false;
	[TabGroup("Generic SpellParameters")] [Tooltip("TimeBeforeTheEndOfCanalisation DOIT ETRE Inferieur AU CANALISATION TIME")] public float anonciationTime;

	[Header("Resolution")]
	[TabGroup("Generic SpellParameters")] public Sc_ForcedMovement forcedMovementAppliedBeforeResolution, forcedMovementAppliedAfterResolution;
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusToApplyOnResolution = new List<Sc_Status>();


	[Header("Throwback")]
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusToApplyAtTheEnd = new List<Sc_Status>();
	[TabGroup("Generic SpellParameters")] public float throwBackDuration;

	[Header("Ui")]
	[TabGroup("Generic SpellParameters")] public Sprite spellIcon;
}