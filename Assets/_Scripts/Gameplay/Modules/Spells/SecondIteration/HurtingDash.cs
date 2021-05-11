using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;
using Sirenix.OdinInspector;

public class HurtingDash : SpellModule
{
	[TabGroup("HitPArt")]
	[SerializeField] float hurtingBoxWidth = .8f;
	[TabGroup("HitPArt")]
	bool hasTouched = false;
	[TabGroup("HitPArt")]
	public float cooldownReduction;
	[TabGroup("HitPArt")]
	[SerializeField] HurtingBox hurtBox;
	ArrowPreview _myPreview;
	[TabGroup("HitPArt")]
	public float dashDurationAddedIfNeeded = .05f;
	//[SerializeField] VisualEffect speedFx;
	[TabGroup("HitPArt")]
	[SerializeField] AudioClip hitDashSound;

	public DamagesInfos damages;
	DamagesInfos _damageToDeal = new DamagesInfos();
	private void Start ()
	{
		ResetDamage();
	}

	void ResetDamage()
	{
		_damageToDeal.damageHealth = damages.damageHealth;
		_damageToDeal.statusToApply = damages.statusToApply;
		_damageToDeal.movementToApply = damages.movementToApply;
	}

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		if (isOwner)
		{
			_myPreview = PreviewManager.Instance.GetArrowPreview();
			_myPreview.gameObject.SetActive(false);
		}
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		base.ShowPreview(mousePos);

	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();
		_myPreview.gameObject.SetActive(true);

		float finalMultiplier = spell.forcedMovementAppliedBeforeResolution.movementToApply.fakeRange;

		RaycastHit _hit;
		if (Physics.Raycast(transform.position, myPlayerModule.directionOfTheMouse(), out _hit, spell.forcedMovementAppliedBeforeResolution.movementToApply.fakeRange, 1 << 9))
			finalMultiplier = Vector3.Distance(transform.position, _hit.point);

		_myPreview.Init(transform.position, transform.position + myPlayerModule.directionOfTheMouse() * finalMultiplier);
	}

	protected override void HidePreview ( Vector3 _posToHide )
	{
		base.HidePreview(_posToHide);
		_myPreview.gameObject.SetActive(false);
	}

	public override void TryCanalysing ( Vector3 _BaseMousePos)
	{
		hurtBox.ResetHitbox();
		ResetDamage();
		hasTouched = false;

		if ((GameManager.Instance.currentLocalPlayer.myPlayerModule.state & En_CharacterState.PoweredUp) != 0 && isOwner)
		{
			_damageToDeal.damageHealth = damages.damageHealth;
			_damageToDeal.damageHealth = (ushort)(damages.damageHealth +1);
			GameManager.Instance.currentLocalPlayer.myPlayerModule.RemoveState(En_CharacterState.PoweredUp);
		}
		else
		{
			_damageToDeal.damageHealth = damages.damageHealth;
		}

		base.TryCanalysing(_BaseMousePos);
	}

	protected override void Resolution ()
	{
		hurtBox.gameObject.SetActive(true);

		myPlayerModule.forcedMovementInterrupted += Interrupt;

		gameObject.layer = 13;

		base.Resolution();
	}

    public override void Interrupt ( bool isInterrupted = false )
	{
		hurtBox.gameObject.SetActive(false);

		gameObject.layer = 7;

		myPlayerModule.forcedMovementInterrupted -= Interrupt;


		base.Interrupt(isInterrupted);
	}

	public void TouchedAnEnemy ( GameObject _hitHostile )
	{
		Damageable _hit = _hitHostile.GetComponent<Damageable>();

		if (_hit != null && !_hit.IsInMyTeam(myPlayerModule.teamIndex))
		{
			_hit.DealDamages(_damageToDeal, transform, myPlayerModule.mylocalPlayer.myPlayerId);

            AudioManager.Instance.Play3DAudioInNetwork(hitDashSound, transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true);

			if (!hasTouched)
			{
				hasTouched = true;
				ReduceCooldown(cooldownReduction);
			}

			if (myPlayerModule.movementPart.currentForcedMovement.duration <= dashDurationAddedIfNeeded)
				myPlayerModule.movementPart.currentForcedMovement.duration += dashDurationAddedIfNeeded;
		}
	}
}