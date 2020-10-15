using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

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
		mylineRender.startWidth = _width;
		mylineRender.endWidth = _width;
	}

	public override void OnDisable ()
	{
		base.OnDisable();
	}

	public override void Update ()
	{
		base.Update();
		
		/*if(currentTimeCanalised <= spell.canalisationTime)
		{
			canalisationCircle.size
		}
		*/
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
					LocalPlayer _tempStack = _hit.collider.GetComponent<LocalPlayer>();
					if (_tempStack.gameObject != gameObject && _tempStack.teamIndex != myPlayerModule.mylocalPlayer.teamIndex)
					{
						DamagesInfos _infos = new DamagesInfos();
						_infos.damages = spell.damagesToDeal;

						_tempStack.DealDamages(_infos);
						allPlayerTouched.Add(_hit.collider.gameObject);
					}
				}
			}
		}
	}

	

	void StartDamaging ( ForcedMovement _forcedMovementInfos )
	{
		directionToDamage = _forcedMovementInfos.direction;
		damaging = true;
	}

	void StopDamaging ()
	{
		damaging = false;
		allPlayerTouched.Clear();
	}

}
