using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[CreateAssetMenu(fileName = "NewSpell", menuName = "CreateCuston/NewSpell/CreatenewDelayedEffect")]

public class Sc_EffectAtEnd : Sc_Spell
{
	[TabGroup("EffectAtTheEnd")] public GameObject objectToSpawnAtThenEnd;
	[TabGroup("EffectAtTheEnd")] public float timeToWaitBeforeSpawning=.5f;
}
