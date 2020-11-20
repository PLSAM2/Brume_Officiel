using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

[InlineEditor]
public class Aoe : AutoKill
{
	[SerializeField] SphereCollider _myColl;
	[SerializeField] DamagesInfos damagesToDealOnImpact;
	[SerializeField] DamagesInfos damagesToDealOnStay;
	List<LocalPlayer> playerTouched =new List<LocalPlayer>();
	[SerializeField] Sc_Spit mySpell;

	private void Start ()
	{
		_myColl = GetComponent<SphereCollider>();
	}

	protected override void OnEnable ()
	{
		mylifeTime = mySpell.durationOfTheAoe;

		base.OnEnable();

		RaycastHit[] _allhits = Physics.SphereCastAll(transform.position, _myColl.radius, Vector3.zero, 0, 1 << 8);
		foreach(RaycastHit _hit in _allhits)
		{
			print(_hit.collider.name);
			LocalPlayer _localPlayer = GetComponent<LocalPlayer>();
			if(_localPlayer.myPlayerModule.teamIndex != myteam)
				_localPlayer.DealDamages(damagesToDealOnImpact);
		}
	}

	private void OnTriggerEnter ( Collider other )
	{
		if (isOwner)
		{
			LocalPlayer _player = other.GetComponent<LocalPlayer>();
			if (_player != null && _player.myPlayerModule.teamIndex != myteam)
			{
				print(_player);
				_player.DealDamages(damagesToDealOnStay);


				if (myLivelifeTime <= .25f)
					_player.DealDamages(damagesToDealOnImpact);

				playerTouched.Add(_player);
			}
		}
	}

	private void OnTriggerExit ( Collider other )
	{
		LocalPlayer _player = other.GetComponent<LocalPlayer>();
		if (_player != null && _player.myPlayerModule.teamIndex != myteam)
		{
			_player.myPlayerModule.StopStatus(damagesToDealOnStay.statusToApply[0].effect.forcedKey);
			playerTouched.Remove(_player);
		}
	}

	protected override void Destroy ()
	{
		if(isOwner)
		{
			foreach (LocalPlayer _player in playerTouched)
			{
				_player.myPlayerModule.StopStatus(damagesToDealOnStay.statusToApply[0].effect.forcedKey);
			}
		}

		base.Destroy();
	}
}