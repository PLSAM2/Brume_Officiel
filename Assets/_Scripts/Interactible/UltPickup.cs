using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UltPickup : Interactible
{
	[SerializeField] Animator myAnimator;
	public ushort ultimateStackGive = 1;
	public ushort hitPointGiven = 1;
	public float brumeExplorationGain = .4f;
	public Sc_Status appliedBonus;
	public Transform captureFx;
	public float maxHeight = 8;
	protected override void Init ()
	{
		fillImg.material.SetFloat(progressShaderName, 1);
		fillImg.material.SetFloat(opacityZoneAlphaShader, 0.2f);
	}

	private void Start ()
	{
		ActualiseMesh();
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
		Debug.Log("I M CAPTURED FRERO");

		using (DarkRiftWriter writer = DarkRiftWriter.Create())
		{
			writer.Write((ushort)1);

			using (Message message = Message.Create(Tags.Heal, writer))
			{
				NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
			}
		}

		//GameManager.Instance.currentLocalPlayer.myPlayerModule.inBrumeValue += brumeExplorationGain;
		 GameManager.Instance.currentLocalPlayer.myPlayerModule.AddState(En_CharacterState.PoweredUp);
		GameManager.Instance.currentLocalPlayer.HealPlayer(hitPointGiven);
		GameManager.Instance.currentLocalPlayer.myPlayerModule.AddStatus(appliedBonus.effect);
		//GameManager.Instance.currentLocalPlayer.AddHitPoint(hitPointGiven);
		base.Captured(_capturingPlayerID);

	}
	public override void UpdateCaptured ( ushort _capturingPlayerID )
	{
		base.UpdateCaptured(_capturingPlayerID);

		//  GameManager.Instance.networkPlayers[_capturingPlayerID].AddHitPoint(hitPointGiven);
		timer = 0;
		ActualiseMesh();
	}

	public override void Unlock ()
	{
		base.Unlock();
		ActualiseMesh();
	}

	void ActualiseMesh ()
	{
		switch (state)
		{
			case State.Locked:
				myAnimator.SetBool("IsActive", false);
				break;

			case State.Capturable:
				myAnimator.SetBool("IsActive", true);
				break;

			case State.Captured:
				myAnimator.SetBool("IsActive", false);
				break;
		}
	}

	protected override void Capture ()
	{
		base.Capture();
		captureFx.transform.localPosition = Vector3.up * maxHeight * Mathf.Clamp(timer / (interactTime / 2), 0, 1);
	}
}
