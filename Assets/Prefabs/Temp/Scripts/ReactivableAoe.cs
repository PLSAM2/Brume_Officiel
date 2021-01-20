using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using static GameData;

public class ReactivableAoe : Aoe
{

	[TabGroup("ReactivationPart")] public En_SpellInput inputLinked;
	[TabGroup("ReactivationPart")] public En_CharacterState stateForbiddenForReactivation = (En_CharacterState.Canalysing | En_CharacterState.Silenced);
	[TabGroup("ReactivationPart")] public float delayBeforeApplyingDamages = .5f;
	[TabGroup("ReactivationPart")] public DamagesInfos damagesToApplyOnReactivation;
	[TabGroup("ReactivationPart")] public bool useCharacterPos;
	LocalPlayer localPlayer;
	bool hasReactivated;

	public override void Init ( GameData.Team ownerTeam )
	{
		base.Init(ownerTeam);

		if (isOwner)
		{
			hasReactivated = false;
			GameManager.Instance.currentLocalPlayer.myPlayerModule.firstSpellInput += Reactivation;
		}
	}

	private void OnDisable ()
	{
		if (!hasReactivated && isOwner)
			GameManager.Instance.currentLocalPlayer.myPlayerModule.firstSpellInput -= Reactivation;
	}

	public void Reactivation ( Vector3 _mousePos )
	{
		print("I try to reactivate");
		if ((GameManager.Instance.currentLocalPlayer.myPlayerModule.state & stateForbiddenForReactivation) == 0 && !hasReactivated)
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
		foreach(Collider _coll in enemiesHit())
		{
			_coll.GetComponent<Damageable>().DealDamages(damagesToApplyOnReactivation, posToGrabTo, GameManager.Instance.currentLocalPlayer.myPlayerId);
		}

	}
}
