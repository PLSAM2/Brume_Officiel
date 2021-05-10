using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine.Events;
using static GameData;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;
	SquarePreview squarePreview;
	ArrowPreview myPreviewArrow;
	DamagesInfos damageToDeal = new DamagesInfos();

	bool isLaser = false;

	[SerializeField] bool useAnonciation = false;
	[ShowIf("useAnonciation")] public Transform firstFx, secondFx;
	[ShowIf("useAnonciation")] public LineRenderer lineLaser, linePreview;
	bool hasHit = false;
	public UnityEvent playerHit;



	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		localTrad = (Sc_CacAttack)spell;
		ResetDamage();

		squarePreview = PreviewManager.Instance.GetSquarePreview();
		squarePreview.gameObject.SetActive(false);
		myPreviewArrow = PreviewManager.Instance.GetArrowPreview();
		myPreviewArrow.gameObject.SetActive(false);

		if (useAnonciation)
		{
			lineLaser.useWorldSpace = true;
			linePreview.useWorldSpace = true;
		}
	}
	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		base.StartCanalysing(_BaseMousePos);

		if ((myPlayerModule.state & En_CharacterState.PoweredUp) != 0)
			damageToDeal.damageHealth += 1;
		else
			ResetDamage();

		GameManager.Instance.currentLocalPlayer.myPlayerModule.RemoveState(En_CharacterState.PoweredUp);
	}

	protected override void UpdatePreview ()
	{
		base.UpdatePreview();
		if (localTrad.forcedMovementAppliedBeforeResolution != null)

		{
			RaycastHit _hit;
			if (Physics.SphereCast(transform.position,
				.8f,
				transform.forward,
				out _hit,
				localTrad.forcedMovementAppliedBeforeResolution.movementToApply.fakeRange,
				1 << 9))
			{
				myPreviewArrow.Init(transform.position, _hit.point, 1, 1);
				myPreviewArrow.gameObject.SetActive(true);
			}
			else
			{
				myPreviewArrow.Init(transform.position, transform.position + (Vector3.Normalize(myPlayerModule.mousePos() - transform.position) * (localTrad.forcedMovementAppliedBeforeResolution.movementToApply.fakeRange)), 1, 1);
				//myPreviewArrow[1].gameObject.SetActive(true);

			}

		}
		else
			squarePreview.Init(maxRangeOfTheSpell(), localTrad.attackParameters.widthToAttackFrom, transform.eulerAngles.y, SquarePreview.squareCenter.border, transform.position);
	}

	float maxRangeOfTheSpell ()
	{
		RaycastHit _hit;
		if (Physics.BoxCast(transform.position, new Vector3(localTrad.attackParameters.widthToAttackFrom, 1, .2f),
			transform.forward,
			out _hit,
			transform.rotation,
			spell.range,
			LayerMask.GetMask("Environment")))
			return Vector3.Distance(transform.position, _hit.point);
		else
			return spell.range;
	}

	protected override void ShowPreview ( Vector3 mousePos )
	{
		if (canBeCast())
		{
			if (localTrad.forcedMovementAppliedBeforeResolution != null)
			{
				myPreviewArrow.gameObject.SetActive(true);
			}
			else
				squarePreview.gameObject.SetActive(true);
		}
		base.ShowPreview(mousePos);
	}

	protected override void HidePreview ( Vector3 _temp )
	{
		base.HidePreview(_temp);
		if (localTrad.forcedMovementAppliedBeforeResolution != null)
		{
			myPreviewArrow.gameObject.SetActive(false);
		}
		else
			squarePreview.gameObject.SetActive(false);
	}


	protected override void Resolution ()
	{
		List<GameObject> _listHit = new List<GameObject>();
		if (LaserHit(_listHit).Count > 0)
		{
			startResolution = true;
			FeedbackSpellStep(En_SpellStep.Resolution);
			ResolveSpell();
		}
		else
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
			base.Resolution();
		}
	}
	protected override void ResolveSpell ()
	{
		ResolveSlash();
		base.ResolveSpell();
	}

	/*void SlashDetection()
	{
		if(startResolution)
		{
			List<GameObject> _listHit = new List<GameObject>();

			if (LaserHit(_listHit).Count > 0)
				myPlayerModule.movementPart.
		}
	}*/

	void ResolveSlash (bool _useless=false)
	{

		HidePreview(Vector3.zero);

		if (spell.forcedMovementAppliedBeforeResolution != null)
		{
			myPlayerModule.forcedMovementInterrupted -= ResolveSlash;
		}


		if (willResolve)
		{
			List<GameObject> _listHit = new List<GameObject>();

			//float _angle = -attackToResolve.angleToAttackFrom / 2;
			//RAYCAST POUR TOUCHER
			_listHit.AddRange(LaserHit(_listHit));


			_listHit.Remove(gameObject);
			bool _ashitEnemy = false;
			foreach (GameObject _go in _listHit)
			{
				Damageable _playerTouched = _go.GetComponent<Damageable>();

				if (_playerTouched != null)
					if (!_playerTouched.IsInMyTeam(myPlayerModule.teamIndex))
					{
						_playerTouched.DealDamages(localTrad.attackParameters.damagesToDeal, transform);
						_ashitEnemy = true;
					}
			}

			if (_ashitEnemy)
			{
				TriggerAnimHit();

				playerHit?.Invoke();
			}
		}
	}

	List<GameObject> LaserHit ( List<GameObject> _listHit )
	{
		List<GameObject> _toAdd = new List<GameObject>();

		RaycastHit[] _allhits = (Physics.BoxCastAll(transform.position, new Vector3(localTrad.attackParameters.widthToAttackFrom, 1, .1f), transform.forward, transform.rotation, spell.range, 1 << 8));

		float distance = 100;
		RaycastHit _hit;
		if (Physics.BoxCast(transform.position, new Vector3(localTrad.attackParameters.widthToAttackFrom, 1, .1f), transform.forward, out _hit, transform.rotation, spell.range, 1 << 9))
			distance = Vector3.Distance(_hit.point, transform.position);

		//verif que le gameobject est pas deja dansa la liste
		for (int j = 0; j < _allhits.Length; j++)
		{
			if (!_listHit.Contains(_allhits[j].collider.gameObject) && !_toAdd.Contains(_allhits[j].collider.gameObject) &&
					distance > Vector3.Distance(_allhits[j].transform.position, transform.position))
			{
				_toAdd.Add(_allhits[j].collider.gameObject);
			}
		}
		return _toAdd;
	}

	protected override void CancelSpell ( bool _isForcedInterrupt )
	{
		base.CancelSpell(_isForcedInterrupt);
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Interrupt");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Interrupt");
		resolved = anonciated = startResolution = true;
		currentTimeCanalised = 0;
		throwbackTime = 0;
		willResolve = false;
		HidePreview(Vector3.zero);
	}

	void ResetDamage ()
	{
		damageToDeal.damageHealth = localTrad.attackParameters.damagesToDeal.damageHealth;
		damageToDeal.movementToApply = localTrad.attackParameters.damagesToDeal.movementToApply;
		damageToDeal.statusToApply = localTrad.attackParameters.damagesToDeal.statusToApply;
	}

	public override void StartCanalysingFeedBack ()
	{
		if (lineLaser != null)
		{
			linePreview.gameObject.SetActive(true);

			linePreview.SetPosition(0, transform.position);
			linePreview.SetPosition(1, transform.position + transform.forward * maxRangeOfTheSpell());
			isLaser = true;
		}

		base.StartCanalysingFeedBack();
	}

	public override void ResolutionFeedBack ()
	{
		if (lineLaser != null)
		{
			linePreview.gameObject.SetActive(false);
			lineLaser.gameObject.SetActive(true);

			lineLaser.SetPosition(0, transform.position + Vector3.up);
			lineLaser.SetPosition(1, transform.position + Vector3.up + transform.forward * maxRangeOfTheSpell());

		}


		base.ResolutionFeedBack();
	}

	public override void ThrowbackEndFeedBack ()
	{
		if (lineLaser != null)
		{
			lineLaser.gameObject.SetActive(false);

			lineLaser.SetPosition(0, transform.position + Vector3.up);
			lineLaser.SetPosition(1, transform.position + Vector3.up + transform.forward * maxRangeOfTheSpell());
			isLaser = false;
		}

		base.ThrowbackEndFeedBack();
	}

	protected override void Update ()
	{
		base.Update();
		if (isLaser)
		{
			linePreview.SetPosition(0, transform.position);
			linePreview.SetPosition(1, transform.position + Vector3.up + transform.forward * maxRangeOfTheSpell());
			lineLaser.SetPosition(0, transform.position);
			lineLaser.SetPosition(1, transform.position + Vector3.up + transform.forward * maxRangeOfTheSpell());
		}
	}

	void TriggerAnimHit ()
	{
		myPlayerModule.mylocalPlayer.myAnimController.SetTriggerToAnim("Slash");
		myPlayerModule.mylocalPlayer.myAnimController.SyncTrigger("Slash");
	}
}
