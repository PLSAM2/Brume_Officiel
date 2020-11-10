using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sc_CacAttack : Sc_Spell
{
	[Header("AutoParameters")]
	public float angleToAttackFrom= 90;
	public float distanceToDash=1;
	public float bumpDistance=.5f, bumpDuration= .05f;
}
