using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UltPickup : Interactible
{
	public ushort ultimateStackGive = 1;
	public ushort hitPointGiven = 1;
	public float brumeExplorationGain = .4f;
	public Sc_Status appliedBonus;
	public float maxHeight = 8;

	public GameObject onCapture, onReaparition, idle;
	protected override void Init ()
	{
		fillImg.material.SetFloat(progressShaderName, 1);
		fillImg.material.SetFloat(opacityZoneAlphaShader, 1f);
	}

	private void Start ()
	{
		idle.SetActive(true);
	}

	public override void TryCapture ( GameData.Team team, PlayerModule capturingPlayer )
	{
		//PlayerData _p = NetworkManager.Instance.GetLocalPlayer();

		//if (_p.ultStacks >= GameData.characterUltMax[_p.playerCharacter])
		//{
		//    print(_p.ultStacks + " - " + GameData.characterUltMax[_p.playerCharacter]);
		//    return;
		//}

		base.TryCapture(team, capturingPlayer);

	}
	public override void Captured ( ushort _capturingPlayerID )
	{
		//GameManager.Instance.currentLocalPlayer.myPlayerModule.inBrumeValue += brumeExplorationGain;
	//	GameManager.Instance.currentLocalPlayer.myPlayerModule.AddState(En_CharacterState.PoweredUp);
		GameManager.Instance.currentLocalPlayer.HealPlayer(hitPointGiven);
		if (appliedBonus != null)
			GameManager.Instance.currentLocalPlayer.myPlayerModule.AddStatus(appliedBonus.effect);
		//GameManager.Instance.currentLocalPlayer.AddHitPoint(hitPointGiven);
		base.Captured(_capturingPlayerID);

	}
	public override void UpdateCaptured ( ushort _capturingPlayerID )
	{
		base.UpdateCaptured(_capturingPlayerID);

		//  GameManager.Instance.networkPlayers[_capturingPlayerID].AddHitPoint(hitPointGiven);
		timer = 0;
		idle.SetActive(false);
		onCapture.SetActive(true);
	}

	public override void Unlock ()
	{
		base.Unlock();
		StartCoroutine(waitForIdle());
	}
	protected override void UpdateMapIcon ()
	{
		return;
	}

	IEnumerator waitForIdle()
	{
		onReaparition.SetActive(true);
		yield return new WaitForSeconds(1.2f);
		onReaparition.SetActive(false);
		idle.SetActive(true);
	}

}
