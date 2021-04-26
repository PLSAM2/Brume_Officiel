using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;
using static GameData;
using UnityEngine.Events;

public class SpellModule : MonoBehaviour
{
	[HideInInspector] public PlayerModule myPlayerModule;

	float _currentTimeCanalised = 0, _throwbackTime = 0;
	bool willResolveFast, isPreped = false;
	[ReadOnly] public float timeToResolveSpell;
	public float throwbackTime { get => _throwbackTime; set { _throwbackTime = value; if (myPlayerModule.mylocalPlayer.isOwner) { UiManager.Instance.UpdateCanalisation(_throwbackTime / spell.throwBackDuration, false); } } }
	public float currentTimeCanalised { get => _currentTimeCanalised; set { _currentTimeCanalised = value; if (myPlayerModule.mylocalPlayer.isOwner) { UiManager.Instance.UpdateCanalisation(currentTimeCanalised / spell.canalisationTime); } } }
	float _cooldown = 0;
	public float cooldown
	{
		get => _cooldown; set
		{
			_cooldown = value;

			if (isOwner)
				UpdateUiCooldown();
		}
	}
	private int _charges;
	[ReadOnly]
	public int charges
	{
		get => _charges;
		set
		{
			_charges = value;
			if (isOwner && _charges > 0 && NetworkManager.Instance.GetLocalPlayer().ultStacks >= spell.stacksUsed)
			{
				CheckForUse();
			}
		}
	}
	[ReadOnly] public bool isUsed = false, startResolution = false, resolved = false, anonciated = false;
	public Sc_Spell spell;
	protected En_SpellInput actionLinked;
	protected bool showingPreview = false;
	protected bool willResolve = false;
	protected bool isOwner = false;
	public bool isAComboPiece = false;
	[HideInInspector] public bool hasPreviewed;
	protected Vector3 mousePosInputed;
	List<Sc_Status> statusToStopAtTheEnd = new List<Sc_Status>();

	//public Action<int> ChargeUpdate;
	public Action SpellAvaible, SpellNotAvaible;

	[Header("FeedBack Spell ")]
	public UnityEvent onCanalisation;
	public UnityEvent onAnnonciation, onResolution, onInterrupt;

	private void OnEnable ()
	{
		LocalPlayer.disableModule += Disable;
	}
	public virtual void SetupComponent ( En_SpellInput _actionLinked )
	{
		myPlayerModule = GetComponent<PlayerModule>();

		actionLinked = _actionLinked;
		isOwner = myPlayerModule.mylocalPlayer.isOwner;

		if (isOwner)
		{
			LinkInputs(_actionLinked);
			charges = 1;
			_cooldown = 0;
			UiManager.Instance.SetupIcon(_actionLinked, spell);

			if(spell.stacksUsed > 0)
				myPlayerModule.ultPointPickedUp += CheckForUse;

			CheckForUse();
		}
	}

	void CheckForUse ()
	{
		if (NetworkManager.Instance.GetLocalPlayer().ultStacks >= spell.stacksUsed)
		{
			SpellAvaible?.Invoke();
		}
	}

	public virtual void Disable ()
	{
		if (isOwner)
		{
			DelinkInput();
		}
	}


	protected virtual void Update ()
	{

		if (isUsed)
		{
			currentTimeCanalised += Time.deltaTime;

			if (willResolveFast)
				TryToResolveInstant(Vector3.zero);

			TreatNormalCanalisation();
			TreatThrowBack();
		}

		if (CanDeacreaseCooldown())
			DecreaseCooldown();

		if (showingPreview)
			UpdatePreview();
	}

	protected virtual void TreatNormalCanalisation ()
	{
		if (currentTimeCanalised >= timeToResolveSpell && anonciated && !startResolution)
		{
			Resolution();
		}
		else if (currentTimeCanalised >= FinalAnonciationTime() && anonciated == false)
		{
			AnonceSpell(Vector3.zero);
		}
	}
	protected virtual void TreatThrowBack ()
	{
		if (resolved)
		{
			throwbackTime += Time.deltaTime;

			if (throwbackTime >= spell.throwBackDuration)
			{
				Interrupt();
			}
		}
	}

	public virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if (canStartCanalisation() && willResolve)
		{
			Canalyse(_BaseMousePos);
		}
		else
			SpellNotAvaible?.Invoke();
	}

	public virtual void TryToResolveInstant(Vector3 _useless)
	{
		if (currentTimeCanalised >= spell.minTimeToResolve && willResolveFast && !isPreped)
		{
			currentTimeCanalised = spell.canalisationTime - spell.anonciationTime;
			isPreped = true;
		}
		else 
		{
			willResolveFast = true;
		}
	}

	void Canalyse ( Vector3 _BaseMousePos )
	{
		if (isOwner)
		{
			timeToResolveSpell = FinalCanalisationTime();

			isPreped = willResolveFast = resolved = anonciated = startResolution = false;
			currentTimeCanalised = 0;
			throwbackTime = 0;
			isUsed = true;
			FeedbackSpellStep(En_SpellStep.Canalisation);
			mousePosInputed = _BaseMousePos;

			ApplyCanalisationEffect();
			DecreaseCharge();

		}
	}
	protected virtual void AnonceSpell ( Vector3 _toAnnounce )
	{
		//certain sort essaye de annonce alors que le sort a deja resolve  => les attaques chargées
		if (isUsed)
		{
			anonciated = true;
			currentTimeCanalised = FinalAnonciationTime();
			FeedbackSpellStep(En_SpellStep.Annonciation);

			if (spell.lockRotOnAnonciation)
				myPlayerModule.rotationLock(true);


			if (spell.LockPosOnAnonciation)
				myPlayerModule.AddState(En_CharacterState.Root);
		}
	}
	protected virtual void Resolution ()
	{
		FeedbackSpellStep(En_SpellStep.Resolution);

		if (ForcedMovementToApplyOnRealisation() != null)
		{
			myPlayerModule.forcedMovementInterrupted += ResolveSpell;
			TreatForcedMovement(spell.forcedMovementAppliedBeforeResolution);
		}
		else
			ResolveSpell();

		startResolution = true;
	}
	protected virtual void ResolveSpell ()
	{
		resolved = true;

		if (ForcedMovementToApplyOnRealisation() != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSpell;
		}

		if (ForcedMovementToApplyAfterRealisation() != null)
			TreatForcedMovement(ForcedMovementToApplyAfterRealisation());

		if (spell.statusToApplyOnResolution.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusToApplyOnResolution)
			{
				statusToStopAtTheEnd.Add(_statusToAdd);
				myPlayerModule.AddStatus(_statusToAdd.effect);
			}
	}


	protected virtual void DecreaseCharge ()
	{
		charges -= 1;

		if (spell.useUltStacks)
		{
			print(spell.stacksUsed);
			RoomManager.Instance.TryUseUltStacks(spell.stacksUsed);
		}
	}
	public virtual void DecreaseCooldown ()
	{
		if (charges < spell.numberOfCharge)
		{
			if (cooldown <= spell.cooldown)
				cooldown += Time.deltaTime;
			else
			{
				cooldown = 0;
				AddCharge();
			}
		}
	}


	public virtual void ForceCanalyse ( Vector3 _BaseMousePos )
	{
		Canalyse(_BaseMousePos);
	}
	protected virtual void ApplyCanalisationEffect ()
	{
		myPlayerModule.AddState(En_CharacterState.Canalysing);


		if (spell.statusToApplyOnCanalisation.Count > 0)
		{
			for (int i = 0; i < spell.statusToApplyOnCanalisation.Count; i++)
			{
				if (spell.statusToApplyOnCanalisation[i].effect.isConstant)
					statusToStopAtTheEnd.Add(spell.statusToApplyOnCanalisation[i]);

				spell.statusToApplyOnCanalisation[i].ApplyStatus(myPlayerModule.mylocalPlayer);
			}
		}

		if (spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(true);

		if (spell.lockPosOnCanalisation)
			myPlayerModule.AddState(En_CharacterState.Root);
	}
	protected virtual void TreatForcedMovement ( Sc_ForcedMovement movementToTreat )
	{
		myPlayerModule.movementPart.AddDash(movementToTreat.MovementToApply(transform.position + transform.forward, transform.position));
	}
	protected virtual void CancelSpell ( bool _isForcedInterrupt )
	{
		if (_isForcedInterrupt && isUsed)
			KillSpell();
		else
		{
			if (showingPreview)
			{
				willResolve = false;
				HidePreview(Vector3.zero);
			}
		}
	}
	public virtual void Interrupt ()
	{
		isUsed = false;
		throwbackTime = 0;
		FeedbackSpellStep(En_SpellStep.Interrupt);

		if (statusToStopAtTheEnd.Count > 0)
			foreach (Sc_Status _statusToRemove in statusToStopAtTheEnd)
				myPlayerModule.StopStatus(_statusToRemove.effect.forcedKey);

		if (spell.lockRotOnAnonciation || spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(false);
		if (spell.lockPosOnCanalisation || spell.LockPosOnAnonciation)
			myPlayerModule.RemoveState(En_CharacterState.Root);
		myPlayerModule.RemoveState(En_CharacterState.Canalysing);

		ApplyEffectAtTheEnd();

		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Interrupt");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Interrupt");

		myPlayerModule.spellResolved?.Invoke();
	}

	protected virtual void ApplyEffectAtTheEnd ()
	{
		if (spell.statusToApplyAtTheEnd.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusToApplyAtTheEnd)
				myPlayerModule.AddStatus(_statusToAdd.effect);

	}

	public virtual void KillSpell ()
	{
		print("The spell as been killed");
		ResolutionFeedBack();
		willResolve = false;
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Interrupt");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Interrupt");
		Interrupt();
	}

	protected virtual void AddCharge ()
	{
		charges++;
	}
	public void ReduceCooldown ( float _durationShorten )
	{
		if (charges < spell.numberOfCharge)
			cooldown += _durationShorten;

	}
	protected virtual bool canBeCast ()
	{
		if (spell.useUltStacks && spell.stacksUsed > RoomManager.Instance.GetPlayerUltStacks(NetworkManager.Instance.GetLocalPlayer().ID))
		{
			return false;
		}

		if (isAComboPiece)
			return true;

		if ((myPlayerModule.state & spell.forbiddenState) != 0 ||
			charges < 1 || isUsed)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	protected virtual bool canStartCanalisation ()
	{
		if (!canBeCast())
			return false;
		else if (hasPreviewed == true)
			return true;
		else
			return false;
	}
	public virtual void FeedbackSpellStep ( En_SpellStep _step )
	{
		switch (_step)
		{
			case En_SpellStep.Canalisation:
				StartCanalysingFeedBack();
				if (isOwner)
					myPlayerModule.mylocalPlayer.UpdateSpellStep(actionLinked, En_SpellStep.Canalisation);
				break;
			case En_SpellStep.Annonciation:
				StartAnnonciationFeedBack();
				if (isOwner)
					myPlayerModule.mylocalPlayer.UpdateSpellStep(actionLinked, En_SpellStep.Annonciation);
				break;
			case En_SpellStep.Resolution:
				ResolutionFeedBack();
				if (isOwner)
					myPlayerModule.mylocalPlayer.UpdateSpellStep(actionLinked, En_SpellStep.Resolution);
				break;
			case En_SpellStep.Interrupt:
				ThrowbackEndFeedBack();
				if (isOwner)
					myPlayerModule.mylocalPlayer.UpdateSpellStep(actionLinked, En_SpellStep.Interrupt);
				break;
		}
	}
	public virtual void StartCanalysingFeedBack ()
	{
		onCanalisation?.Invoke();

		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation0", true);
				//	myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation0", true);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation1", true);
				//	myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation1", true);

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation2", true);
				//	myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation2", true);

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation3", true);
				//	myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation3", true);

				break;
		}
	}
	public virtual void StartAnnonciationFeedBack ()
	{
		onAnnonciation?.Invoke();
	}
	public virtual void ResolutionFeedBack ()
	{
		onResolution?.Invoke();
		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation0", false);
				//	myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation0", false);

				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation1", false);
				//	myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation1", false);

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation2", false);
				//		myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation2", false);

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation3", false);
				//		myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation3", false);
				break;
		}
	}
	public virtual void ThrowbackEndFeedBack ()
	{
		onInterrupt?.Invoke();
	}

	//inputs subscribing
	#region
	protected virtual void LinkInputs ( En_SpellInput _actionLinked )
	{
		myPlayerModule.cancelSpell += CancelSpell;
		myPlayerModule.mylocalPlayer.OnPlayerDeath += HidePreview;

		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.firstSpellInput += ShowPreview;
					myPlayerModule.firstSpellInput += StartCanalysing;
					myPlayerModule.firstSpellInputRealeased += TryToResolveInstant;
				}
				else
				{
					myPlayerModule.firstSpellInput += ShowPreview;
					myPlayerModule.firstSpellInputRealeased += StartCanalysing;
				}
				myPlayerModule.firstSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.secondSpellInput += ShowPreview;
					myPlayerModule.secondSpellInput += StartCanalysing;
					myPlayerModule.secondSpellInputRealeased += TryToResolveInstant;
				}
				else
				{
					myPlayerModule.secondSpellInput += ShowPreview;
					myPlayerModule.secondSpellInputRealeased += StartCanalysing;
				}
				myPlayerModule.secondSpellInputRealeased += HidePreview;
				break;

		/*	case En_SpellInput.ThirdSpell:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.thirdSpellInput += ShowPreview;
					myPlayerModule.thirdSpellInput += StartCanalysing;
					myPlayerModule.thirdSpellInputRealeased += TryToResolveInstant;
				}
				else
				{
					myPlayerModule.thirdSpellInput += ShowPreview;
					myPlayerModule.thirdSpellInputRealeased += StartCanalysing;
				}
				myPlayerModule.thirdSpellInputRealeased += HidePreview;
				break;*/

			case En_SpellInput.Click:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.leftClickInput += ShowPreview;
					myPlayerModule.leftClickInput += StartCanalysing;
					myPlayerModule.leftClickInputRealeased += TryToResolveInstant;
				}
				else
				{
					myPlayerModule.leftClickInput += ShowPreview;
					myPlayerModule.leftClickInputRealeased += StartCanalysing;
				}
				myPlayerModule.leftClickInputRealeased += HidePreview;
				break;

			case En_SpellInput.SoulSpell:
				myPlayerModule.soulSpellInput += ShowPreview;
				myPlayerModule.soulSpellInputReleased += StartCanalysing;
				myPlayerModule.soulSpellInputReleased += HidePreview;
				break;
		}
	}
	protected virtual void RelinkInputs ( Vector3 _useless )
	{
		LinkInputs(actionLinked);
	}
	protected virtual void DelinkInput ()
	{
		myPlayerModule.cancelSpell -= CancelSpell;
		myPlayerModule.mylocalPlayer.OnPlayerDeath -= HidePreview;


		if (spell.stacksUsed > 0)
		{
			myPlayerModule.ultPointPickedUp -= CheckForUse;
		}

		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.firstSpellInput -= ShowPreview;
					myPlayerModule.firstSpellInput -= StartCanalysing;
					myPlayerModule.firstSpellInputRealeased -= TryToResolveInstant;
				}
				else
				{
					myPlayerModule.firstSpellInput -= ShowPreview;
					myPlayerModule.firstSpellInputRealeased -= StartCanalysing;
				}
				myPlayerModule.firstSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.secondSpellInput -= ShowPreview;
					myPlayerModule.secondSpellInput -= StartCanalysing;
					myPlayerModule.secondSpellInputRealeased -= TryToResolveInstant;
				}
				else
				{
					myPlayerModule.secondSpellInput -= ShowPreview;
					myPlayerModule.secondSpellInputRealeased -= StartCanalysing;
				}
				myPlayerModule.secondSpellInputRealeased -= HidePreview;
				break;

		/*	case En_SpellInput.ThirdSpell:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.thirdSpellInput -= ShowPreview;
					myPlayerModule.thirdSpellInput -= StartCanalysing;
					myPlayerModule.thirdSpellInputRealeased -= TryToResolveInstant;
				}
				else
				{
					myPlayerModule.thirdSpellInput -= ShowPreview;
					myPlayerModule.thirdSpellInputRealeased -= StartCanalysing;
				}
				myPlayerModule.thirdSpellInputRealeased -= HidePreview;
				break;
		*/
			case En_SpellInput.Click:
				if (spell.startCanalisationOnClick)
				{
					myPlayerModule.leftClickInput -= ShowPreview;
					myPlayerModule.leftClickInput -= StartCanalysing;
					myPlayerModule.leftClickInputRealeased -= TryToResolveInstant;
				}
				else
				{
					myPlayerModule.leftClickInput -= ShowPreview;
					myPlayerModule.leftClickInputRealeased -= StartCanalysing;
				}
				myPlayerModule.leftClickInputRealeased -= HidePreview;
				break;

			case En_SpellInput.SoulSpell:
				myPlayerModule.soulSpellInput -= ShowPreview;
				myPlayerModule.soulSpellInputReleased -= StartCanalysing;
				myPlayerModule.soulSpellInputReleased -= HidePreview;
				break;
		}
	}
	#endregion

	//canalisation Ressources
	#region
	public virtual bool CanDeacreaseCooldown ()
	{
		return charges < spell.numberOfCharge && !isUsed;
	}

	protected virtual Sc_ForcedMovement ForcedMovementToApplyOnRealisation ()
	{ return spell.forcedMovementAppliedBeforeResolution; }
	protected virtual Sc_ForcedMovement ForcedMovementToApplyAfterRealisation ()
	{ return spell.forcedMovementAppliedAfterResolution; }
	protected virtual float FinalCanalisationTime ()
	{
		return spell.canalisationTime;
	}
	protected virtual float FinalAnonciationTime ()
	{
		return spell.canalisationTime - spell.anonciationTime;
	}
	#endregion

	//UI
	#region
	protected virtual void UpdateUiCooldown ()
	{
		if (!isAComboPiece)
			UiManager.Instance.UpdateUiCooldownSpell(actionLinked, _cooldown, spell.cooldown);
	}
	#endregion

	//PREVIEW
	#region

	protected virtual void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())
		{
			willResolve = true;
			showingPreview = true;
			UpdatePreview();
			hasPreviewed = true;
		}
		else
			return;
	}
	protected virtual void HidePreview ( Vector3 _posToHide )
	{
		showingPreview = false;
		hasPreviewed = false;
	}
	protected virtual void UpdatePreview ()
	{

	}
	#endregion
}
public enum En_SpellInput
{
	Null,
	Click = 1,
	FirstSpell = 2,
	SecondSpell = 3,
	ThirdSpell = 4,
	TP = 5,
	Maj,
	SoulSpell,
	Special,
	Ping
}