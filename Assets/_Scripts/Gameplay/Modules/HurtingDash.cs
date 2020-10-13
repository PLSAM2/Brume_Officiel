﻿using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class HurtingDash : DashModule
{
	[SerializeField] LayerMask characterLayer;
	bool damaging = false;
	Vector3 directionToDamage;
	List<GameObject> allPlayerTouched = new List<GameObject>();
	float _width;
	public override void SetupComponent ()
	{
		base.SetupComponent();
		myPlayerModule.forcedMovementAdded += StartDamaging;
		myPlayerModule.forcedMovementInterrupted += StopDamaging;
		_width  = (spell as Sc_DashSpell).damagesRadius;
		mylineRender.SetWidth(_width, _width);
	}

	public override void OnDisable ()
	{
		base.OnDisable();
	}

	public override void Update ()
	{
		base.Update();
		if (damaging)
		{
			List<RaycastHit> _allitemsTouched = Physics.CapsuleCastAll(transform.position - new Vector3(0, 0.5f, 0), transform.position + new Vector3(0, 0.5f, 0), _width, directionToDamage, _width / 2, characterLayer).ToList();

			foreach (RaycastHit _hit in _allitemsTouched)
			{
				bool isNew = true;

				foreach (GameObject _GO in allPlayerTouched)
				{
					if (_hit.collider.gameObject == _GO)
					{
						isNew = false;
						break;
					}
				}

				if (isNew)
				{
					PlayerModule _tempStack = _hit.collider.GetComponent<PlayerModule>();
					if (_tempStack.gameObject != gameObject && _tempStack.teamIndex != myPlayerModule.teamIndex)
					{
						DamagesInfos _infos = new DamagesInfos();
						_infos.playerName = myPlayerModule.myName;
						_infos.damages = spell.damagesToDeal;

						_tempStack.DealDamages(_infos);
						allPlayerTouched.Add(_hit.collider.gameObject);
					}
				}
			}
		}
	}


	void StartDamaging ( ForcedMovement _forcedmvementInfos )
	{
		directionToDamage = _forcedmvementInfos.direction;
		damaging = true;
	}

	void StopDamaging ()
	{
		damaging = false;
		allPlayerTouched.Clear();
	}
}
