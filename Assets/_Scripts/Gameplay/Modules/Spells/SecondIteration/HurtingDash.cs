using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;

public class HurtingDash : SpellModule
{
	[SerializeField] float hurtingBoxWidth = .8f;
	public DamagesInfos damages;
	bool hasTouched = false;
	public float cooldownReduction;
	[SerializeField] HurtingBox hurtBox;
	ArrowPreview _myPreview;
	public float dashDurationAddedIfNeeded = .05f;

    [SerializeField] List<ParticleSystem> dashFx = new List<ParticleSystem>();
    //[SerializeField] VisualEffect speedFx;

    [SerializeField] AudioClip hitDashSound;

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

	public override void StartCanalysing ( Vector3 _BaseMousePos)
	{
		hurtBox.ResetHitbox();
		hasTouched = false;
		base.StartCanalysing(_BaseMousePos);
	}

	protected override void Resolution ()
	{
		hurtBox.gameObject.SetActive(true);

		myPlayerModule.forcedMovementInterrupted += Interrupt;

		gameObject.layer = 13;

		base.Resolution();
	}

    public override void ResolutionFeedBack()
    {
        base.ResolutionFeedBack();

        foreach(ParticleSystem fx in dashFx)
        {
            fx.Play();
        }

        //speedFx.Play();
    }

    public override void ThrowbackEndFeedBack()
    {
        base.ThrowbackEndFeedBack();

        foreach (ParticleSystem fx in dashFx)
        {
            fx.Stop();
        }
        //speedFx.Stop();
    }

    public override void Interrupt ()
	{
		hurtBox.gameObject.SetActive(false);

		gameObject.layer = 7;

		myPlayerModule.forcedMovementInterrupted -= Interrupt;

		base.Interrupt();
	}

	public void TouchedAnEnemy ( PlayerModule _hitHostile )
	{
		Damageable _hit = _hitHostile.GetComponent<Damageable>();

		if (_hit != null && !_hit.IsInMyTeam(myPlayerModule.teamIndex))
		{
			_hit.DealDamages(damages, transform.position, myPlayerModule.mylocalPlayer.myPlayerId);

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