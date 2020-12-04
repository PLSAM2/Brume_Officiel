using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "newCounter", menuName = "CreateCuston/newCounter")]
public class Sc_Counter : Sc_Spell
{
	public DamagesInfos damagesToDealer;
	public List<Sc_Status> StatusToApplyToSelf;
}
