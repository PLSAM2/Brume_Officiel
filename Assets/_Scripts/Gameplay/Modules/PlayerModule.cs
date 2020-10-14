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

	[ReadOnly] public ushort myId;
	[ReadOnly] public string myName;
	[SerializeField] Camera mainCam;
	[SerializeField] LayerMask groundLayer;
	[HideInInspector] public LocalPlayer myLocalPlayer;

	[Header("DamagesPart")]
	[ReadOnly] public En_CharacterState state;
	[ReadOnly] public List<DamagesInfos> allHitTaken = new List<DamagesInfos>(); 


	[Header("CharacterBuilder")]
	public MovementModule movementPart;
	[SerializeField] SpellModule firstSpell, secondSpell, thirdSpell, leftClick;
	[SerializeField] CapsuleCollider coll;


	//ALL ACTION 
	#region
	public Action<Vector3> DirectionInputedUpdate;
	//spell
	public Action<Vector3> firstSpellInput, secondSpellInput, thirdSpellInput, leftClickInput;
	public Action<Vector3> firstSpellInputRealeased, secondSpellInputRealeased, thirdSpellInputRealeased, leftClickInputRealeased;
	//run
	public Action toggleRunning, stopRunning;
	//otherMovements
	public Action<ForcedMovement> forcedMovementAdded;
	public Action forcedMovementInterrupted;
	public Action<MovementModifier> addMovementModifier;

	//Animation
	public Action<Vector3> onSendMovement;
	#endregion

	void Start ()
	{
		movementPart.SetupComponent(characterParameters.movementParameters, coll);

		UiManager.instance.myPlayerModule = this;

		myLocalPlayer = GetComponent<LocalPlayer>();

		firstSpell?.SetupComponent();
		secondSpell?.SetupComponent();
		thirdSpell?.SetupComponent();
		leftClick?.SetupComponent();
	}

	void Update ()
	{
		//rot player
		LookAtMouse();
		//direction des fleches du clavier 
		DirectionInputedUpdate.Invoke(directionInputed());

		//INPUT DETECTION SPELLS AND RUNNING
		#region
		
		if (Input.GetKeyDown(firstSpellKey))
			firstSpellInput?.Invoke(mousePos());
		else if (Input.GetKeyDown(secondSpellKey))
			secondSpellInput?.Invoke(mousePos());
		else if (Input.GetKeyDown(thirdSpellKey))
			thirdSpellInput?.Invoke(mousePos());
		//AUTO
		else if (Input.GetAxis("Fire1") > 0)
		{
			leftClickInput?.Invoke(mousePos());
		}
		//RUNNING
		else if (Input.GetKeyDown(KeyCode.LeftShift))
			toggleRunning?.Invoke();

		if (Input.GetKeyUp(firstSpellKey))
			firstSpellInputRealeased?.Invoke(mousePos());
		else if (Input.GetKeyDown(secondSpellKey))
			secondSpellInputRealeased?.Invoke(mousePos());
		else if (Input.GetKeyDown(thirdSpellKey))
			thirdSpellInputRealeased?.Invoke(mousePos());
		#endregion
	}

	

	void LookAtMouse ()
	{
		Vector3 _currentMousePos = mousePos();
		transform.LookAt(new Vector3(_currentMousePos.x, 0, _currentMousePos.z));
	}
	//Vars 
	#region 
	public Vector3 directionInputed ()
	{
		return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
	}
	public Vector3 mousePos ()
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
	Slowed = 1 << 0,
	SpedUp = 1 << 1,
	Stunned = 1 << 2,
	Canalysing = 1 << 3,
}


[System.Serializable]
public class ForcedMovement
{
	public PlayerModule myModule;
	float _duration = 0;
	public float duration
	{
		get => _duration; set
		{
			_duration = value; if (_duration <= 0) {  myModule.forcedMovementInterrupted.Invoke(); }
		}
	}
	Vector3 _direction;
	public Vector3 direction { get => _direction; set { _direction = Vector3.Normalize(value); } }
	public float strength;
}

[System.Serializable]
public class MovementModifier
{
	public float percentageOfTheModifier, duration;
}


[System.Serializable]
public class DamagesInfos
{
	public DamagesParameters damages;
	public string playerName;
}


[System.Serializable]
public class DamagesParameters
{
	public ushort damageHealth;
}



