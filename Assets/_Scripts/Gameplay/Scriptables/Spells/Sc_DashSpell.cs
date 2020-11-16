using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/DashSpell")]
public class Sc_DashSpell : Sc_Spell
{
    public bool adaptiveRange;
    public float timeToReachMaxRange;
    public float damagesRadius;

    public DamagesInfos damages;

	[Header("Bonus")]
	public int bonusDash;
}