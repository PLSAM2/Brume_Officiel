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
			UiManager.Instance.UpdateChargesUi(charges, actionLinked);
		}
	}

	float _cooldown = 0;
	[ReadOnly] public bool isUsed = false, startResolution = false,  resolved = false, anonciated = false;
	public Sc_Spell spell;
	protected En_SpellInput actionLinked;
	protected bool showingPreview = false;

	[HideInInspector] public PlayerModule myPlayerModule;

	List<Sc_Status> statusToStopAtTheEnd = new List<Sc_Status>();
	protected Vector3 mousePosInputed;

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
			LinkInput(_actionLinked);
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
			DelinkInput(actionLinked);

			myPlayerModule.upgradeKit -= UpgradeSpell;
			myPlayerModule.backToNormalKit -= ReturnToNormal;
		}
	}

	//inputs subscribing
	#region
	protected virtual void LinkInput ( En_SpellInput _actionLinked )
	{
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

	protected virtual void DelinkInput ( En_SpellInput _actionLinked )
	{
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
			showingPreview = true;
			UpdatePreview();
		}
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

	protected void TreatThrowBack ()
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
		if (canBeCast())
		{
			resolved = anonciated= startResolution = false;
			currentTimeCanalised = 0;
			throwbackTime = 0;

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
	}

	protected virtual void TreatForcedMovement ( Sc_ForcedMovement movementToTreat )
	{
		myPlayerModule.movementPart.AddDash(movementToTreat.MovementToApply(transform.position + transform.forward, transform.position));
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
		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation0", true);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation0", true);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation1", true);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation1", true);

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation2", true);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation2", true);

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation3", true);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation3", true);

				break;
		}
	}

	void AnonciationFeedBack ()
	{
		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation0", false);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation0", false);

				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation1", false);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation1", false);

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation2", false);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation2", false);

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.SetBoolToAnim("SpellCanalisation3", false);
				myPlayerModule.mylocalPlayer.SendAnimationBool("SpellCanalisation3", false);

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