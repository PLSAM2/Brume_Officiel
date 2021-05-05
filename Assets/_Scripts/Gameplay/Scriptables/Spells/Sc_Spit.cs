using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
[CreateAssetMenu(fileName = "NewSpit", menuName = "CreateCuston/NewSpell/NewSpit")]

public class Sc_Spit : Sc_Spell
{
	[TabGroup("Spit  Parameters")] public GameObject onImpactInstantiate;
	[TabGroup("Spit  Parameters")] public float radiusOfImpact;
}

