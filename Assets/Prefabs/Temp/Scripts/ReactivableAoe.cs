using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class ReactivableAoe : Aoe
{

	[TabGroup("ReactivationPart")] public float delayBeforeApplyingDamages = .5f;
	[TabGroup("ReactivationPart")] public DamagesInfos damagesToApplyOnReactivation;
	[TabGroup("ReactivationPart")] public bool useCharacterPos;
	LocalPlayer localPlayer;
	bool hasReactivated;

	public override void Init ( GameData.Team ownerTeam, float _lifePercentage )
	{
		base.Init(ownerTeam, _lifePercentage);
		print(isOwner);

		if (isOwner)
		{
			hasReactivated = false;
			GameManager.Instance.currentLocalPlayer.myPlayerModule.firstSpellInput += Reactivation;
		}
	}

	protected override void OnDisable ()
	{
		if (!hasReactivated && isOwner)
			GameManager.Instance.currentLocalPlayer.myPlayerModule.firstSpellInput -= Reactivation;
	}

	public void Reactivation ( Vector3 _mousePos )
	{
		if (!hasReactivated)
		{
			GameManager.Instance.currentLocalPlayer.myPlayerModule.firstSpellInput -= Reactivation;
			hasReactivated = true;

			/*LocalPoolManager.Instance.SpawnNewGenericInNetwork(3, transform.position + Vector3.up * 0.1f, transform.eulerAngles.y, localTrad.rules.aoeRadius);*/
			StartCoroutine(DelayBeforeApplyDamages());
		}
	}

	IEnumerator DelayBeforeApplyDamages ()
	{
		Vector3 posToGrabTo = GameManager.Instance.currentLocalPlayer.transform.position;
		yield return new WaitForSeconds(delayBeforeApplyingDamages);
	
		/*
		foreach(Collider _coll in enemiesHit())
		{
			print(_coll.name);
			_coll.GetComponent<Damageable>().DealDamages(damagesToApplyOnReactivation, posToGrabTo, GameManager.Instance.currentLocalPlayer.myPlayerId);
		}
		*/
	}
}
