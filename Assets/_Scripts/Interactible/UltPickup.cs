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

	public GameObject fxSpawn, circleCapture;

	public AudioClip takePickUp;

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
		GameManager.Instance.currentLocalPlayer.HealPlayer(hitPointGiven);
		if (appliedBonus != null)
			GameManager.Instance.currentLocalPlayer.myPlayerModule.AddStatus(appliedBonus.effect);
		base.Captured(_capturingPlayerID);

	

		AudioManager.Instance.Play2DAudio(takePickUp);
	}

	public override void UpdateCaptured ( ushort _capturingPlayerID )
	{
		base.UpdateCaptured(_capturingPlayerID);

		onReaparition.SetActive(false);
		idle.SetActive(false);
		onCapture.SetActive(true);

		circleCapture.SetActive(false);
		circleCapture.SetActive(true);

		fxSpawn.SetActive(false);
		//  GameManager.Instance.networkPlayers[_capturingPlayerID].AddHitPoint(hitPointGiven);
		timer = 0;
	}

	public override void Unlock ()
	{
		base.Unlock();
		StartCoroutine("waitForIdle");
	}

	protected override void UpdateMapIcon ()
	{
		return;
	}

	IEnumerator waitForIdle ()
	{
		if (state == State.Capturable)
		{
			onReaparition.SetActive(true);
			idle.SetActive(false);
			fxSpawn.SetActive(true);
			onCapture.SetActive(false);
			circleCapture.SetActive(false);
		}
		yield return new WaitForSeconds(1.2f);
		if (state == State.Capturable)
		{
			onReaparition.SetActive(false);
			idle.SetActive(true);
		}
	}

}
