using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using UnityEngine.Video;

[InlineEditor]
[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/BaseSpell")]
public class Sc_Spell : ScriptableObject
{
	[Header("General Properties")]
	[TabGroup("Generic SpellParameters")] public float range;
	[TabGroup("Generic SpellParameters")] public float cooldown;
	[TabGroup("Generic SpellParameters")] public int numberOfCharge = 1;
	[TabGroup("Generic SpellParameters")] public En_CharacterState forbiddenState = En_CharacterState.Canalysing | En_CharacterState.Silenced;
	[TabGroup("Generic SpellParameters")] public bool useUltStacks => stacksUsed>0;
	[TabGroup("Generic SpellParameters")] public ushort stacksUsed = 0;
	[TabGroup("Generic SpellParameters")] public bool isInterruptedOnOtherTentative = false;

	[Header("StartCanalisation")]
	[TabGroup("Generic SpellParameters")] public bool lockRotOnCanalisation = true;
	[TabGroup("Generic SpellParameters")] public bool lockPosOnCanalisation = false;
	[TabGroup("Generic SpellParameters")] public float canalisationTime;
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusToApplyOnCanalisation = new List<Sc_Status>();

	[Header("Anonciation")]
	[TabGroup("Generic SpellParameters")] public bool lockRotOnAnonciation = true;
	[TabGroup("Generic SpellParameters")] public bool LockPosOnAnonciation = false;
	[TabGroup("Generic SpellParameters")] [Tooltip("TimeBeforeTheEndOfCanalisation DOIT ETRE Inferieur AU CANALISATION TIME")] public float anonciationTime;
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusOnAnnonciation = new List<Sc_Status>();


	[Header("Resolution")]
	[TabGroup("Generic SpellParameters")] public Sc_ForcedMovement forcedMovementAppliedBeforeResolution, forcedMovementAppliedAfterResolution;
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusToApplyOnResolution = new List<Sc_Status>();


	[Header("Throwback")]
	[TabGroup("Generic SpellParameters")] public List<Sc_Status> statusToApplyAtTheEnd = new List<Sc_Status>();
	[TabGroup("Generic SpellParameters")] public float throwBackDuration;

	[TabGroup("Generic SpellParameters")]
	[TabGroup("Ui")] public Sprite spellIcon;
	[TabGroup("Ui")] public string spellName = "MyNameIsStan";
	[TextArea(15, 20)]
	[TabGroup("Ui")] public string spellDescription = "My Description";
    [TabGroup("Ui")] public VideoClip myVideoSpell;

}