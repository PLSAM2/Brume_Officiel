using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/DashSpell")]
public class Sc_DashSpell : Sc_Spell
{
	[TabGroup("Dash Specification")] public ForcedMovement movementToApply;

	[Header("Bonus")]
	[TabGroup("Dash Specification")] public int bonusDash;
}