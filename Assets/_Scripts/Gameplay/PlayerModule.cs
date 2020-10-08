using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class PlayerModule : MonoBehaviour
{
	[Header("Inputs")]
	public KeyCode firstSpellKey = KeyCode.A, secondSpellKey = KeyCode.E, thirdSpellKey= KeyCode.R;

	[Header("GameplayInfos")]
	public Sc_CharacterParameters characterParameters;
	public En_CharacterState state;

	[ReadOnly] public ushort myId;
	[HideInInspector] public int teamIndex { get; set; }


	[Header("CharacterBuilder")]
	[SerializeField] MovementModule movementPart;
	[SerializeField] SpellModule firstSpell, secondSpell, thirdSpell;
	[SerializeField] CapsuleCollider coll;

	//ALL ACTION 
	public static Action<Vector3, ushort> DirectionInputedUpdate;
	//spell
	public static Action firstSpellInput, secondSpellInput, thirdSpellInput;

	void Start ()
	{
		movementPart.SetupComponent(characterParameters.movementParameters, coll);
	}

	void Update ()
	{
		DirectionInputedUpdate.Invoke(directionInputed(), myId);

		if (canCast())
		{
			if (Input.GetKeyDown(firstSpellKey))
				firstSpellInput?.Invoke();
			else if (Input.GetKeyDown(secondSpellKey))
				secondSpellInput?.Invoke();
			else if (Input.GetKeyDown(thirdSpellKey))
				thirdSpellInput?.Invoke();
		}
	}

	bool canCast ()
	{
		if ((~state & En_CharacterState.Canalysing) == 0 && (~state & En_CharacterState.Stunned) == 0)
			return true;
		else
			return false;

	}

	Vector3 directionInputed ()
	{
		return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
	}
}

[System.Flags]
public enum En_CharacterState
{
	None = 1 >> 0,
	Slowed = 1 >> 1,
	SpedUp = 1 >> 2,
	Stunned = 1 >> 3,
	Canalysing = 1 >> 4,
}