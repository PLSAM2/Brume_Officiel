using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class PlayerModule : MonoBehaviour
{
	[Header("Inputs")]
	public KeyCode firstSpellKey = KeyCode.A;
	public KeyCode secondSpellKey = KeyCode.E, thirdSpellKey = KeyCode.R;


	[Header("GameplayInfos")]
	public Sc_CharacterParameters characterParameters;
	[ReadOnly] public En_CharacterState state = En_CharacterState.None;

	[ReadOnly] public ushort myId;
	[HideInInspector] public int teamIndex { get; set; }
	[SerializeField] Camera mainCam;
	[SerializeField] LayerMask groundLayer;


	[Header("CharacterBuilder")]
	[SerializeField] MovementModule movementPart;
	[SerializeField] SpellModule firstSpell, secondSpell, thirdSpell, leftClick;
	[SerializeField] CapsuleCollider coll;

	//ALL ACTION 
	public static Action<Vector3> DirectionInputedUpdate;
	//spell
	public static Action<Vector3> firstSpellInput, secondSpellInput, thirdSpellInput, leftClickInput;
	public static Action ToggleRunning, StopRunning;

	void Start ()
	{
		movementPart.SetupComponent(characterParameters.movementParameters, coll);

		firstSpell?.SetupComponent();
		secondSpell?.SetupComponent();
		thirdSpell?.SetupComponent();
		leftClick?.SetupComponent();
	}

	void Update ()
	{
		DirectionInputedUpdate.Invoke(directionInputed());

		LookAtMouse();

		if (canCast())
		{
			if (Input.GetKeyDown(firstSpellKey))
				firstSpellInput?.Invoke(mousePos());

			else if (Input.GetKeyDown(secondSpellKey))
				secondSpellInput?.Invoke(mousePos());

			else if (Input.GetKeyDown(thirdSpellKey))
				thirdSpellInput?.Invoke(mousePos());

			else if (Input.GetAxis("Fire1") > 0)
				leftClickInput?.Invoke(mousePos());

			else if (Input.GetKeyDown(KeyCode.LeftShift))
				ToggleRunning?.Invoke();
		}
	}

	void LookAtMouse()
	{
		Vector3 _currentMousePos = mousePos();
		transform.LookAt(new Vector3(_currentMousePos.x, transform.position.y, _currentMousePos.z));
	}
	//Vars 
	#region 
	bool canCast ()
	{
		//	if ((~state & En_CharacterState.Canalysing) == 0 && (~state & En_CharacterState.Stunned) == 0)
		return true;
		//else
		//	return false;

	}

	Vector3 directionInputed ()
	{
		return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
	}
	Vector3 mousePos ()
	{
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		RaycastHit hit;

		if (Physics.Raycast(ray, out hit, Mathf.Infinity, groundLayer))
		{
			return hit.point;
		}
		else
		{
			return Vector3.zero;
		}
	}
	#endregion
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