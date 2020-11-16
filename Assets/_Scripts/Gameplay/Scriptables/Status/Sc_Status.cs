using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
[CreateAssetMenu(fileName = "NewStatus", menuName = "CreateCuston/Status")]
public class Sc_Status : ScriptableObject
{
	public Effect effect;

	public virtual void ApplyStatus (PlayerModule target)
	{
		target.AddStatus(effect);
	}
}
