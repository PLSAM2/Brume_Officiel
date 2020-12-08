using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell, throwbackTime;

	[ReadOnly]
	public float cooldown
	{
		get => _cooldown; set
		{
			_cooldown = value;

			UiManager.Instance.UpdateUiCooldownSpell(actionLinked, _cooldown, finalCooldownValue());
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
			if (_charges == spell.numberOfCharge)
				cooldown = finalCooldownValue();

			UiManager.Instance.UpdateChargesUi(charges, actionLinked);
			ChargeUpdate?.Invoke(charges);
		}
	}

	float _cooldown = 0;
	[ReadOnly] public bool isUsed = false, startResolution = false, resolved = false, anonciated = false;
	public Sc_Spell spell;

	protected En_SpellInput actionLinked;
	protected bool showingPreview = false;
	protected bool willResolve = false;
	[HideInInspector] public PlayerModule myPlayerModule;
	protected Vector3 mousePosInputed;
	List<Sc_Status> statusToStopAtTheEnd = new List<Sc_Status>();

	public AudioClip canalisationClip;
	public AudioClip anonciationClip;
	public Action<int> ChargeUpdate;
	private void OnEnable ()
	{
		LocalPlayer.disableModule += Disable;
	}

	//setup & inputs
	public virtual void SetupComponent ( En_SpellInput _actionLinked )
	{
		myPlayerModule = GetComponent<PlayerModule>();
		cooldown = finalCooldownValue();
		actionLinked = _actionLinked;

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			LinkInputs(_actionLinked);
			UiManager.Instance.SetupIcon(spell, _actionLinked);

			timeToResolveSpell = spell.canalisationTime;
			charges = spell.numberOfCharge;
			//action 
			myPlayerModule.upgradeKit += UpgradeSpell;
			myPlayerModule.backToNormalKit += ReturnToNormal;
		}
		else
			DestroyIfClient();
	}


	protected virtual void Disable ()
	{
		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			DelinkInput();

			myPlayerModule.upgradeKit -= UpgradeSpell;
			myPlayerModule.backToNormalKit -= ReturnToNormal;
		}
	}

	//inputs subscribing
	#region
	protected virtual void LinkInputs ( En_SpellInput _actionLinked )
	{
		myPlayerModule.cancelSpell += CancelSpell;

		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += ShowPreview;
				myPlayerModule.firstSpellInputRealeased += StartCanalysing;
				myPlayerModule.firstSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += ShowPreview;
				myPlayerModule.secondSpellInputRealeased += StartCanalysing;
				myPlayerModule.secondSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += ShowPreview;
				myPlayerModule.thirdSpellInputRealeased += StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased += HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += ShowPreview;
				myPlayerModule.leftClickInputRealeased += StartCanalysing;
				myPlayerModule.leftClickInputRealeased += HidePreview;
				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput += ShowPreview;
				myPlayerModule.wardInputReleased += StartCanalysing;
				myPlayerModule.wardInputReleased += HidePreview;
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

		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;
				myPlayerModule.firstSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= ShowPreview;
				myPlayerModule.secondSpellInputRealeased -= StartCanalysing;
				myPlayerModule.secondSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= ShowPreview;
				myPlayerModule.thirdSpellInputRealeased -= StartCanalysing;
				myPlayerModule.thirdSpellInputRealeased -= HidePreview;
				break;

			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= ShowPreview;
				myPlayerModule.leftClickInputRealeased -= StartCanalysing;
				myPlayerModule.leftClickInputRealeased -= HidePreview;
				break;

			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;
				myPlayerModule.wardInputReleased -= HidePreview;
				break;
		}
	}
	#endregion

	protected virtual void DestroyIfClient ()
	{
		Destroy(this);
	}

	//PREVIEW
	#region
	protected virtual void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())
		{
			willResolve = true;
			showingPreview = true;
			UpdatePreview();
		}
		else
			return;
	}

	protected virtual void HidePreview ( Vector3 _posToHide )
	{
		showingPreview = false;
	}

	protected virtual void UpdatePreview ()
	{

	}
	#endregion

	protected virtual void FixedUpdate ()
	{
		if (isUsed)
		{
			currentTimeCanalised += Time.fixedDeltaTime;
			TreatNormalCanalisation();
		}

		if (charges < spell.numberOfCharge && !isUsed)
			DecreaseCooldown();

		if (showingPreview)
			UpdatePreview();

		TreatThrowBack();
	}

	protected virtual void TreatNormalCanalisation ()
	{
		if (currentTimeCanalised >= timeToResolveSpell && anonciated && !startResolution)
		{
			Resolution();
		}
		else if (currentTimeCanalised >= timeToResolveSpell - spell.anonciationTime && anonciated == false)
		{
			AnonceSpell(Vector3.zero);
		}
	}

	protected virtual void TreatThrowBack ()
	{
		if (resolved && throwbackTime <= spell.throwBackDuration && isUsed)
		{
			throwbackTime += Time.fixedDeltaTime;
			if (throwbackTime >= spell.throwBackDuration)
				Interrupt();
		}
	}

	protected virtual void AnonceSpell ( Vector3 _toAnnounce )
	{
		//certain sort essaye de annonce alors que le sort a deja resolve  => les attaques chargées
		if (isUsed)
		{
			AnonciationFeedBack();
			anonciated = true;
			currentTimeCanalised = TimeToWaitOnanonciation();

			if (spell.lockRotOnAnonciation)
				myPlayerModule.rotationLock(true);


			if (spell.LockPosOnAnonciation)
				myPlayerModule.AddState(En_CharacterState.Root);
		}
	}

	protected virtual float TimeToWaitOnanonciation ()
	{
		return spell.canalisationTime - spell.anonciationTime;
	}
	protected virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if (canBeCast() && willResolve)
		{
			resolved = anonciated = startResolution = false;
			currentTimeCanalised = 0;
			throwbackTime = 0;
			myPlayerModule.AddState(En_CharacterState.Canalysing);
			isUsed = true;
			StartCanalysingFeedBack();
			DecreaseCharge();
			mousePosInputed = myPlayerModule.mousePos();

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
		else
			return;
	}
	protected virtual void Resolution ()
	{
		if (spell.forcedMovementAppliedBeforeResolution != null)
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



		if (spell.forcedMovementAppliedBeforeResolution != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSpell;
		}

		if (spell.forcedMovementAppliedAfterResolution != null)
			TreatForcedMovement(spell.forcedMovementAppliedAfterResolution);

		if (spell.statusToApplyOnResolution.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusToApplyOnResolution)
			{
				statusToStopAtTheEnd.Add(_statusToAdd);
				myPlayerModule.AddStatus(_statusToAdd.effect);
			}
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
			else if (isUsed)
			{
				AddCharge();
				KillSpell();
			}
		}
	}
	public virtual void Interrupt ()
	{
		isUsed = false;
		throwbackTime = 0;

		if (statusToStopAtTheEnd.Count > 0)
			foreach (Sc_Status _statusToRemove in statusToStopAtTheEnd)
				myPlayerModule.StopStatus(_statusToRemove.effect.forcedKey);

		if (spell.statusToApplyAtTheEnd.Count > 0)
			foreach (Sc_Status _statusToAdd in spell.statusToApplyAtTheEnd)
				myPlayerModule.AddStatus(_statusToAdd.effect);

		myPlayerModule.RemoveState(En_CharacterState.Canalysing);

		if (spell.lockPosOnCanalisation || spell.LockPosOnAnonciation)
			myPlayerModule.RemoveState(En_CharacterState.Root);

		if (spell.lockRotOnAnonciation || spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(false);

	}
	protected virtual void KillSpell ()
	{
		AnonciationFeedBack();
		willResolve = false;
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Interrupt");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Interrupt");
		Interrupt();
	}
	protected virtual void DecreaseCharge ()
	{
		charges -= 1;
	}

	public virtual void DecreaseCooldown ()
	{
		if (charges < spell.numberOfCharge)
		{
			if (cooldown >= 0)
				cooldown -= Time.fixedDeltaTime;
			else
			{
				cooldown = finalCooldownValue();
				AddCharge();
			}
		}
	}

	protected virtual void AddCharge ()
	{
		charges++;
	}

	protected virtual void UpgradeSpell () { }

	protected virtual void ReturnToNormal () { }

	public void ReduceCooldown ( float _durationShorten )
	{
		if (cooldown != finalCooldownValue())
			cooldown -= _durationShorten;
	}

	protected virtual bool canBeCast ()
	{
		if ((myPlayerModule.state & spell.forbiddenState) != 0 ||
			charges == 0 || isUsed)
		{
			return false;
		}
		else
		{
			return true;
		}
	}



	void StartCanalysingFeedBack ()
	{
		//PITIT BRUIT
		AudioManager.Instance.Play3DAudioInNetwork(canalisationClip, transform.position);

		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation0", true);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation0", true);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation1", true);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation1", true);

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation2", true);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation2", true);

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation3", true);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation3", true);

				break;
		}
	}

	protected virtual void AnonciationFeedBack ()
	{
		//PITIT BRUIT
		AudioManager.Instance.Play3DAudioInNetwork(anonciationClip, transform.position);

		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation0", false);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation0", false);

				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation1", false);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation1", false);

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation2", false);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation2", false);

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.myAnimController.SetBoolToAnim("SpellCanalisation3", false);
				myPlayerModule.mylocalPlayer.myAnimController.SyncBoolean("SpellCanalisation3", false);
				break;
		}
	}

	protected virtual float finalCooldownValue ()
	{
		return spell.cooldown + spell.throwBackDuration;
	}


}
public enum En_SpellInput
{
	FirstSpell,
	SecondSpell,
	ThirdSpell,
	Click,
	Maj,
	Ward,
}