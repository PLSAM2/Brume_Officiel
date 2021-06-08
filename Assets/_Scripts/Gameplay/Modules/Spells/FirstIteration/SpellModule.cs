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
	[ReadOnly] public float timeToResolveSpell;
	public float throwbackTime { get => _throwbackTime; set { _throwbackTime = value; if (myPlayerModule.mylocalPlayer.isOwner) { myPlayerModule.mylocalPlayer.myUiPlayerManager.UpdateCanalisation(_throwbackTime / spell.throwBackDuration, false); } } }
	public float currentTimeCanalised { get => _currentTimeCanalised; set { _currentTimeCanalised = value; if (myPlayerModule.mylocalPlayer.isOwner) { myPlayerModule.mylocalPlayer.myUiPlayerManager.UpdateCanalisation(currentTimeCanalised / spell.canalisationTime); } } }
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

		}
	}
	[ReadOnly] public bool isUsed = false, startResolution = false, resolved = false, anonciated = false;
	public Sc_Spell spell;
	protected En_SpellInput actionLinked;
	protected bool showingPreview = false;
	protected bool willResolve = false;
	protected bool isOwner = false;
	[HideInInspector] public bool hasPreviewed;
	protected Vector3 mousePosInputed;

	//public Action<int> ChargeUpdate;
	public Action SpellAvaible, SpellNotAvaible;

	[Header("FeedBack Spell ")]
	public UnityEvent onCanalisation;
	public UnityEvent onAnnonciation, onResolution, onInterrupt;
	bool ispreviewed = false;
	//setup
	#region
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
		}
	}
	public virtual void Disable ()
	{
		if (isOwner)
		{
			DelinkInput();
		}
	}

	//inputs subscribing
	#region
	public virtual void LinkInputs ( En_SpellInput _actionLinked )
	{
		myPlayerModule.cancelSpell += CancelSpell;
		myPlayerModule.mylocalPlayer.OnPlayerDeath += HidePreview;
		myPlayerModule.OnSpellTryCanalisation += TryToKillSpell;
		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += ShowPreview;
				myPlayerModule.firstSpellInputRealeased += TryCanalysing;
				myPlayerModule.firstSpellInputRealeased += HidePreview;
				myPlayerModule.secondSpellInput += HidePreview;
				myPlayerModule.leftClickInput += HidePreview;
				myPlayerModule.soulSpellInput += HidePreview;

				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += ShowPreview;
				myPlayerModule.secondSpellInputRealeased += TryCanalysing;
				myPlayerModule.secondSpellInputRealeased += HidePreview;
				myPlayerModule.firstSpellInput += HidePreview;
				myPlayerModule.leftClickInput += HidePreview;
				myPlayerModule.soulSpellInput += HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += ShowPreview;
				myPlayerModule.leftClickInputRealeased += TryCanalysing;
				myPlayerModule.leftClickInputRealeased += HidePreview;
				myPlayerModule.firstSpellInput += HidePreview;
				myPlayerModule.secondSpellInput += HidePreview;
				myPlayerModule.soulSpellInput += HidePreview;
				break;

			case En_SpellInput.SoulSpell:
				myPlayerModule.soulSpellInput += ShowPreview;
				myPlayerModule.soulSpellInputReleased += TryCanalysing;
				myPlayerModule.soulSpellInputReleased += HidePreview;
				myPlayerModule.firstSpellInput += HidePreview;
				myPlayerModule.secondSpellInput += HidePreview;
				myPlayerModule.leftClickInput += HidePreview;
				break;
		}
	}
	protected virtual void RelinkInputs ( Vector3 _useless )
	{
		LinkInputs(actionLinked);
	}
	public virtual void DelinkInput ()
	{
		myPlayerModule.cancelSpell -= CancelSpell;
		myPlayerModule.mylocalPlayer.OnPlayerDeath -= HidePreview;
		myPlayerModule.OnSpellTryCanalisation -= TryToKillSpell;

		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= TryCanalysing;
				myPlayerModule.firstSpellInputRealeased -= HidePreview;
				myPlayerModule.secondSpellInput -= HidePreview;
				myPlayerModule.leftClickInput -= HidePreview;
				myPlayerModule.soulSpellInput -= HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= ShowPreview;
				myPlayerModule.secondSpellInputRealeased -= TryCanalysing;
				myPlayerModule.secondSpellInputRealeased -= HidePreview;
				myPlayerModule.firstSpellInput -= HidePreview;
				myPlayerModule.leftClickInput -= HidePreview;
				myPlayerModule.soulSpellInput -= HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= ShowPreview;
				myPlayerModule.leftClickInputRealeased -= TryCanalysing;
				myPlayerModule.leftClickInputRealeased -= HidePreview;
				myPlayerModule.firstSpellInput -= HidePreview;
				myPlayerModule.secondSpellInput -= HidePreview;
				myPlayerModule.soulSpellInput -= HidePreview;
				break;

			case En_SpellInput.SoulSpell:
				myPlayerModule.soulSpellInput -= ShowPreview;
				myPlayerModule.soulSpellInputReleased -= TryCanalysing;
				myPlayerModule.soulSpellInputReleased -= HidePreview;
				myPlayerModule.firstSpellInput -= HidePreview;
				myPlayerModule.secondSpellInput -= HidePreview;
				myPlayerModule.leftClickInput -= HidePreview;
				break;
		}
	}
	#endregion
	#endregion

	//updates
	#region
	protected virtual void Update ()
	{
		if (isUsed)
		{
			currentTimeCanalised += Time.deltaTime;
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
	#endregion

	//PREVIEW
	#region

	protected virtual void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())
		{
			UiManager.Instance.UpdateSpellIconState(actionLinked, En_IconStep.selectionned);
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
		if (showingPreview)
		{
			if (charges > 0)
				UiManager.Instance.UpdateSpellIconState(actionLinked, En_IconStep.ready);
			else
				UiManager.Instance.UpdateSpellIconState(actionLinked, En_IconStep.inCd);
		}
		showingPreview = false;
		hasPreviewed = false;
	}
	protected virtual void UpdatePreview ()
	{

	}
	#endregion

	//SPELL STEPS
	#region 
	public virtual void TryCanalysing ( Vector3 _BaseMousePos )
	{

		myPlayerModule.OnSpellTryCanalisation?.Invoke(spell);

		if (canStartCanalisation() && willResolve)
		{
			Canalyse(_BaseMousePos);
		}
		else
			UiManager.Instance.CantCastFeedback(actionLinked);
		/*SpellNotAvaible?.Invoke();*/
	}
	protected virtual void Canalyse ( Vector3 _BaseMousePos )
	{
		if (isOwner)
		{
			myPlayerModule.mylocalPlayer.SendRotation();
			myPlayerModule.mylocalPlayer.myUiPlayerManager.HideCanalisationBar(true);

			myPlayerModule.currentSpellResolved = spell;
			timeToResolveSpell = FinalCanalisationTime();

			resolved = anonciated = startResolution = false;
			currentTimeCanalised = 0;
			throwbackTime = 0;
			isUsed = true;

			FeedbackSpellStep(En_SpellStep.Canalisation);

			mousePosInputed = _BaseMousePos;

			ApplyCanalisationEffect();
			DecreaseCharge();

		}
	}
	public virtual void StartCanalysingFeedBack ()
	{
		onCanalisation?.Invoke();
		myPlayerModule.mylocalPlayer.SendRotation();

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
					spell.statusToApplyOnCanalisation[i].ApplyStatus(myPlayerModule.mylocalPlayer);
			}
		}

		if (spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(true);

		if (spell.lockPosOnCanalisation)
			myPlayerModule.AddState(En_CharacterState.Root);
	}
	protected virtual void AnonceSpell ( Vector3 _toAnnounce )
	{
		//certain sort essaye de annonce alors que le sort a deja resolve  => les attaques chargées
		if (isUsed)
		{
			myPlayerModule.mylocalPlayer.SendRotation();
			anonciated = true;
			currentTimeCanalised = FinalAnonciationTime();
			FeedbackSpellStep(En_SpellStep.Annonciation);

			if (spell.lockRotOnAnonciation)
				myPlayerModule.rotationLock(true);


			if (spell.LockPosOnAnonciation)
				myPlayerModule.AddState(En_CharacterState.Root);

			if (spell.statusOnAnnonciation.Count > 0)
			{
				for (int i = 0; i < spell.statusOnAnnonciation.Count; i++)
				{
					if (spell.statusOnAnnonciation[i].effect.isConstant)
						spell.statusOnAnnonciation[i].ApplyStatus(myPlayerModule.mylocalPlayer);
				}
			}

			if (spell.statusToApplyOnCanalisation.Count > 0)
				foreach (Sc_Status _statusToAdd in spell.statusToApplyOnCanalisation)
				{
					myPlayerModule.StopStatus(_statusToAdd.effect.forcedKey);
				}

		}
	}
	public virtual void StartAnnonciationFeedBack ()
	{
		onAnnonciation?.Invoke();
	}
	protected virtual void Resolution ()
	{
		FeedbackSpellStep(En_SpellStep.Resolution);
		myPlayerModule.mylocalPlayer.SendRotation();

		if (ForcedMovementToApplyOnRealisation() != null)
		{
			myPlayerModule.forcedMovementInterrupted += ForceResolveSpell;
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
			myPlayerModule.forcedMovementInterrupted -= ForceResolveSpell;
		}

		if (ForcedMovementToApplyAfterRealisation() != null)
			TreatForcedMovement(ForcedMovementToApplyAfterRealisation());

		if (spell.statusToApplyOnResolution.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusToApplyOnResolution)
			{
				myPlayerModule.AddStatus(_statusToAdd.effect);
			}

		if (spell.statusOnAnnonciation.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusOnAnnonciation)
			{
				myPlayerModule.StopStatus(_statusToAdd.effect.forcedKey);
			}
	}
	void ForceResolveSpell ( bool _isForced )
	{
		ResolveSpell();
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
	protected virtual void TreatForcedMovement ( Sc_ForcedMovement movementToTreat )
	{
		myPlayerModule.movementPart.AddDash(movementToTreat.MovementToApply(transform.position + transform.forward, transform.position));
	}
	public virtual void Interrupt ( bool _isInterrupte = false )
	{
		isUsed = false;


		myPlayerModule.spellResolved?.Invoke();
		myPlayerModule.currentSpellResolved = null;
		currentTimeCanalised = 0;
		throwbackTime = 0;
		myPlayerModule.mylocalPlayer.myUiPlayerManager.HideCanalisationBar(false);

		//status applied
		if (spell.statusToApplyOnCanalisation.Count > 0)
			foreach (Sc_Status _statusToRemove in spell.statusToApplyOnCanalisation)
				myPlayerModule.StopStatus(_statusToRemove.effect.forcedKey);

		if (spell.statusOnAnnonciation.Count > 0)
			foreach (Sc_Status _statusToRemove in spell.statusOnAnnonciation)
				myPlayerModule.StopStatus(_statusToRemove.effect.forcedKey);

		if (spell.statusToApplyOnResolution.Count > 0)
			foreach (Sc_Status _statusToRemove in spell.statusToApplyOnResolution)
				myPlayerModule.StopStatus(_statusToRemove.effect.forcedKey);

		if (spell.lockRotOnAnonciation || spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(false);
		if (spell.lockPosOnCanalisation || spell.LockPosOnAnonciation)
			myPlayerModule.RemoveState(En_CharacterState.Root);

		myPlayerModule.RemoveState(En_CharacterState.Canalysing);

		ApplyEffectAtTheEnd();

		//feedbacks
		FeedbackSpellStep(En_SpellStep.Interrupt);
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Interrupt");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Interrupt");
		myPlayerModule.mylocalPlayer.SendRotation();

	}
	public virtual void ThrowbackEndFeedBack ()
	{
		onInterrupt?.Invoke();
	}

	protected virtual void ApplyEffectAtTheEnd ()
	{
		if (spell.statusToApplyAtTheEnd.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusToApplyAtTheEnd)
				myPlayerModule.AddStatus(_statusToAdd.effect);
	}
	#endregion


	protected virtual void CancelSpell ( bool _isForcedInterrupt )
	{
		if (_isForcedInterrupt && isUsed)
		{
			KillSpell();
		}
		else if (showingPreview)
		{
			willResolve = false;
			HidePreview(Vector3.zero);
		}
	}
	public virtual void KillSpell ()
	{
		willResolve = false;
		myPlayerModule.mylocalPlayer.UpdateSpellStep(actionLinked, En_SpellStep.Interrupt);
		Interrupt();
	}
	void TryToKillSpell ( Sc_Spell _spell )
	{
		if (spell.isInterruptedOnOtherTentative && myPlayerModule.currentSpellResolved == spell && _spell != myPlayerModule.currentSpellResolved)
		{
			Interrupt();
		}
	}
	public void ReduceCooldown ( float _durationShorten )
	{
		if (charges < spell.numberOfCharge)
			cooldown += _durationShorten;
	}

	//networkfeedbacks
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

	//usefullVariables
	#region
	protected virtual bool canBeCast ()
	{
		if (spell.useUltStacks && spell.stacksUsed > RoomManager.Instance.GetPlayerUltStacks(NetworkManager.Instance.GetLocalPlayer().ID))
		{
			return false;
		}

		if ((myPlayerModule.state & spell.forbiddenState) != 0 ||
			charges < 1 ||
			isUsed ||
			!GameManager.Instance.gameStarted)
		{
			return false;
		}
		else if (myPlayerModule.currentSpellResolved != null && !myPlayerModule.currentSpellResolved.isInterruptedOnOtherTentative)
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
	protected virtual void AddCharge ()
	{
		charges++;
		SpellAvaible?.Invoke();
		UiManager.Instance.UpdateSpellIconState(actionLinked, En_IconStep.ready);
	}
	protected virtual void DecreaseCharge ()
	{
		charges -= 1;
		UiManager.Instance.UpdateSpellIconState(actionLinked, En_IconStep.inCd);

		if (spell.useUltStacks)
		{
			RoomManager.Instance.TryUseUltStacks(spell.stacksUsed);
		}
	}
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
		UiManager.Instance.UpdateUiCooldownSpell(actionLinked, _cooldown, spell.cooldown);
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