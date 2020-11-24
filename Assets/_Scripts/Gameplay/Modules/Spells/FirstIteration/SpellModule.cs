using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;

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
	[ReadOnly] public bool isUsed = false, resolved;
	public Sc_Spell spell;

	protected En_SpellInput actionLinked;
	public Action<float> cooldownUpdatefirstSpell;
	[ReadOnly] public Vector3 recordedMousePosOnInput;
	[ReadOnly] public PlayerModule myPlayerModule;
	public Action startCanalisation, endCanalisation;
	public ParticleSystem canalisationParticle;
	public List<ParticleSystem> particleResolution;
	protected Vector3 lastRecordedDirection = Vector3.zero;
	protected bool showingPreview =false;

	private void OnEnable ()
	{
		LocalPlayer.disableModule += Disable;
	}

	//setup & inputs
	#region
	public virtual void SetupComponent ( En_SpellInput _actionLinked )
	{
		myPlayerModule = GetComponent<PlayerModule>();


		actionLinked = _actionLinked;

		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			LinkInput(_actionLinked);
			UiManager.Instance.SetupIcon(spell, _actionLinked);

			timeToResolveSpell = spell.canalisationTime;
			charges = spell.numberOfCharge;

			//action 
			startCanalisation += StartCanalysingFeedBack;
			endCanalisation += ResolveSpellFeedback;
			myPlayerModule.upgradeKit += UpgradeSpell;
			myPlayerModule.backToNormalKit += ReturnToNormal;
		}
		else
			DestroyIfClient();
	}

	protected virtual void LinkInput ( En_SpellInput _actionLinked )
	{
		switch (_actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += ShowPreview;
				myPlayerModule.firstSpellInputRealeased += StartCanalysing;

				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += ShowPreview;
				myPlayerModule.secondSpellInputRealeased += StartCanalysing;
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += ShowPreview;
				myPlayerModule.thirdSpellInputRealeased += StartCanalysing;
				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += ShowPreview;
				myPlayerModule.leftClickInputRealeased += StartCanalysing;
				break;
			case En_SpellInput.Ward:
				myPlayerModule.wardInput += ShowPreview;
				myPlayerModule.wardInputReleased += StartCanalysing;
				break;
		}
	}

	protected virtual void Disable ()
	{
		if (myPlayerModule.mylocalPlayer.isOwner)
		{
			DelinkInput(actionLinked);

			startCanalisation -= StartCanalysingFeedBack;
			endCanalisation -= ResolveSpellFeedback;

			myPlayerModule.upgradeKit -= UpgradeSpell;
			myPlayerModule.backToNormalKit -= ReturnToNormal;
		}
	}

	protected virtual void DelinkInput ( En_SpellInput _actionLinked )
	{
		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;

				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;

				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;

				break;
			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= ShowPreview;
				myPlayerModule.firstSpellInputRealeased -= StartCanalysing;

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

	protected virtual void HidePreview()
	{
		showingPreview = false;
	}

	protected virtual void UpdatePreview()
	{

	}
	#endregion

	protected virtual void FixedUpdate ()
	{
		if (isUsed && !resolved)
		{
			currentTimeCanalised += Time.fixedDeltaTime;
			TreatNormalCanalisation();
		}

		if (charges < spell.numberOfCharge && !isUsed)
			DecreaseCooldown();

		if (showingPreview)
			UpdatePreview();
	}

	protected virtual void TreatNormalCanalisation ()
	{
		if (currentTimeCanalised >= timeToResolveSpell)
		{
			if (spell.useLastRecordedMousePos)
				ResolveSpell(recordedMousePosOnInput);
			else
				ResolveSpell(myPlayerModule.mousePos());
		}
	}

	protected virtual void StartCanalysing ( Vector3 _BaseMousePos )
	{
		if (canBeCast())
		{
			//HidePreview();
			startCanalisation?.Invoke();

			if (spell.canalysingStatus != null)
				spell.canalysingStatus.ApplyStatus(myPlayerModule.mylocalPlayer);

			lastRecordedDirection = myPlayerModule.directionInputed();

			resolved = false;

			DecreaseCharge();


			if (charges == spell.numberOfCharge)
				cooldown = finalCooldownValue();

			recordedMousePosOnInput = _BaseMousePos;

			if (spell.lockRotOnCanalisation)
				myPlayerModule.rotationLock(true);

			isUsed = true;
		}
		else
			return;
	}

	protected virtual void DecreaseCharge ()
	{
		charges -= 1;
	}

	public virtual void Interrupt ()
	{
		isUsed = false;
		currentTimeCanalised = 0;
		endCanalisation?.Invoke();
		
		myPlayerModule.RemoveState(En_CharacterState.Canalysing);
		myPlayerModule.RemoveState(En_CharacterState.Root);

		if (cooldown <= 0)
			cooldown = finalCooldownValue();

		if (spell.lockRotOnCanalisation)
			myPlayerModule.rotationLock(false);

	}

	protected virtual void ResolveSpell ( Vector3 _mousePosition )
	{
		resolved = true;
		Interrupt();
	}

	public virtual void DecreaseCooldown ()
	{
		if (charges < spell.numberOfCharge)
		{
			if (cooldown >= 0)
				cooldown -= Time.fixedDeltaTime;
			else
			{
				AddCharge();
				cooldown = finalCooldownValue();
			}
		}
	}

	protected virtual void AddCharge()
    {
		charges += 1;
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
		ApplyStatusCanalisation();

		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation0", true);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation1", true);
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation2", true);
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation3", true);
				break;
		}
	}

	protected virtual void ApplyStatusCanalisation()
	{

		if (spell.lockPosOnCanalisation)
			myPlayerModule.AddState((En_CharacterState.Canalysing | En_CharacterState.Root));
		else
			myPlayerModule.AddState(En_CharacterState.Canalysing);

		
	}

	void ResolveSpellFeedback ()
	{
		//	myPlayerModule.mylocalPlayer.triggerAnim.Invoke("Resolve");
		if (spell.resolusionStatus != null)
			spell?.resolusionStatus.ApplyStatus(myPlayerModule.mylocalPlayer);

		if (particleResolution.Count > 0)
		{
			for (int i = 0; i < particleResolution.Count; i++)
			{
				particleResolution[i].Play();
			}
		}

		switch (actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation0", false);
				break;
			case En_SpellInput.FirstSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation1", false);
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation2", false);
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.mylocalPlayer.BoolTheAnim("SpellCanalisation3", false);
				break;
		}
	}

	public void StartParticleCanalisation ()
	{
		canalisationParticle.Play();
	}

	protected virtual float durationOfTheMovementModifier ()
	{
		return spell.canalisationTime;
	}

	public void StopParticleCanalisation ()
	{
		canalisationParticle.Stop();
	}

	protected virtual float finalCooldownValue ()
	{
		return spell.cooldown;
	}
}

public enum En_SpellInput
{
	FirstSpell,
	SecondSpell,
	ThirdSpell,
	Click,
	Maj,
	Ward
}