
using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class Altar : Interactible
{
	[SerializeField] Sprite unlockedAltar;

	[Header("Altar properties")]
	public int life;
	public float unlockTime;
	public AltarBuff altarBuff;
	public ushort ultimateStackGive = 2;
	public AltarUiProgressCollider altarUiProgressCol;

	[SerializeField] AudioClip unlockAltarSfx;
	[SerializeField] AudioClip capturedAltarSfx;
	[SerializeField] AudioClip unlockAltarVoice;
	[SerializeField] AudioClip capturedAltarVoice;
	[HideInInspector] public float currentTime = 0;

	[SerializeField] protected MeshRenderer completeObj;
	[SerializeField] protected Animator anim;
	[SerializeField] protected string colorShader = "_Color";
	//wayPoint
	[SerializeField] GameObject waypointAltarPrefab;
	[HideInInspector] public AltarWaypoint waypointObj;

	public GameObject redTaken, blueTaken;

	[SerializeField] SpriteRenderer iconUnlock, iconLock;
	public ParticleSystem particleCapturingAlly, particleCapturingEnemy;
	public MeshRenderer onCaptureMesh, centerMesh;
	public GameObject[] allBraseros;
	void Start ()
	{
		base.Init();

		GameManager.Instance.OnPlayerDie += OnPlayerDie;
		isInteractable = false;

		waypointObj = Instantiate(waypointAltarPrefab, UiManager.Instance.parentWaypoint).GetComponent<AltarWaypoint>();
		waypointObj.SetLock();
		waypointObj.gameObject.SetActive(false);
		waypointObj.target = transform;

	//	completeObj.material.SetColor(colorShader, Color.white);
		GameManager.Instance.allAltar.Add(this);

		iconUnlock.gameObject.SetActive(false);
		iconLock.gameObject.SetActive(true);
		foreach (GameObject _obj in allBraseros)
			_obj.SetActive(false);
	}

	private void OnDisable ()
	{
		GameManager.Instance.OnPlayerDie -= OnPlayerDie;
	}

	private void Update ()
	{
		//TODO afficher timer altar
		if (waypointObj != null && waypointObj.gameObject.activeSelf)
		{
			if (currentTime > 0)
			{
				waypointObj.SetTimer(Mathf.RoundToInt(currentTime));
			}
			else
			{
				waypointObj.SetTimer(0);
			}

			currentTime -= Time.deltaTime;
		}
		else
		{
			waypointObj.SetTimer(0);
		}
	}

	protected override void OnTriggerExit ( Collider other )
	{
		base.OnTriggerExit(other);

		if (playerInZone.Count == 0)
		{
			var _emission = particleCapturingAlly.emission;
			_emission.rateOverTime = 0;

			var _emission1 = particleCapturingEnemy.emission;
			_emission1.rateOverTime = 0;
		}

	}

	protected override void VisualCaptureProgress ()
	{
		if (isViewed && reloading == false)
		{
			fillImg.material.SetFloat(progressShaderName, 1 - captureCurve.Evaluate((timer / interactTime)));

			if (altarUiProgressCol.IsplayerInUIZoneContainLocalPlayer())
			{
				if (capturingTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
				{
					UiManager.Instance.altarCaptureProgressBar.gameObject.SetActive(true);
					UiManager.Instance.altarCaptureProgressBar.fillAmount = Mathf.Lerp(UiManager.Instance.altarCaptureProgressBar.fillAmount, timer / interactTime, Time.deltaTime * 2); // parce que fuck le réseau
				}
				else
				{
					UiManager.Instance.altarCaptureProgressBar.gameObject.SetActive(false);
				}

			}

		}
	}

	public override void UpdateCaptured ( ushort _capturingPlayerID )
	{

		// Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
		PlayerData capturePlayer = RoomManager.Instance.GetPlayerData(_capturingPlayerID);

		if (NetworkManager.Instance.GetLocalPlayer().ID != _capturingPlayerID)
		{
			anim.SetTrigger("Captured");
			completeObj.material.SetColor(colorShader, GameFactory.GetRelativeColor(capturePlayer.playerTeam));
			completeObj.gameObject.SetActive(true);
		}
		else
		{
			PlayerPrefs.SetInt("CaptureNbr", PlayerPrefs.GetInt("CaptureNbr") + 1);
		}
		base.UpdateCaptured(_capturingPlayerID);

		onCaptureMesh.material.SetColor("_ColorBase1", GameFactory.GetColorTeam(capturePlayer.playerTeam));
		onCaptureMesh.material.SetColor("_ColorBase2", GameFactory.GetSecondaryColorTeam(capturePlayer.playerTeam));
		//disable
		waypointObj.SetLock();
		waypointObj.gameObject.SetActive(false);

        print("test");

		if (capturePlayer.playerTeam == NetworkManager.Instance.GetLocalPlayer().playerTeam)
		{
			blueTaken.SetActive(true);
			UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.blue) + ">YOUR TEAM </color>", capturedAltarSfx);
		}
		else
		{
			redTaken.SetActive(true);
			UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTAR CLEANSED BY " + "<color=" + GameFactory.GetColorTeamInHex(Team.red) + ">ENEMY TEAM </color>", capturedAltarSfx);
		}

		AudioManager.Instance.Play2DAudio(capturedAltarVoice);
		UiManager.Instance.OnAltarUnlock(this, capturePlayer.playerTeam);

		StatManager.Instance.AddAltarEvent(capturePlayer.playerTeam);

		iconUnlock.color = GameFactory.GetRelativeColor(capturePlayer.playerTeam);
		StatManager.Instance.AddCapture(capturePlayer.playerTeam);
	}

	public override void Captured ( ushort _capturingPlayerID )
	{
		if (altarBuff != null)
		{
			altarBuff.InitBuff(capturingPlayerModule);
		}

		particleCapturingEnemy.Stop();
		particleCapturingAlly.Stop();

		anim.SetTrigger("Captured");
		completeObj.material.SetColor(colorShader, GameFactory.GetRelativeColor(RoomManager.Instance.GetPlayerData(_capturingPlayerID).playerTeam));
		completeObj.gameObject.SetActive(true);

		foreach (GameObject _obj in allBraseros)
			_obj.SetActive(false);
		/*
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)capturingPlayerModule.teamIndex);
            writer.Write(ultimateStackGive);

            using (Message message = Message.Create(Tags.AddUltimatePointToAllTeam, writer))
            {
               NetworkManager.Instance.GetLocalClient().SendMessage(message, SendMode.Reliable);
            }
        }
        */

		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(capturingPlayerModule.teamIndex))
		{
			GameManager.Instance.numberOfAltarControled++;
		}
		else
		{
			GameManager.Instance.numberOfAltarControledByEnemy++;
		}


		base.Captured(_capturingPlayerID);
	}

	public override void UpdateTryCapture ( ushort _capturingPlayerID )
	{
		base.UpdateTryCapture(_capturingPlayerID);
	}


	public override void SetActiveState ( bool value )
	{
		base.SetActiveState(value);
		UiManager.Instance.UnlockNewAltar(this);
		if (value)
		{
			StartCoroutine(ActivateAltar());
		}
	}


	public bool annonceUnlock = true;
	IEnumerator ActivateAltar ()
	{
		if (RoomManager.Instance.roundCount == 1)
		{
			currentTime = unlockTime + GameManager.Instance.trainTimer;
		}
		else
		{
			currentTime = unlockTime;
		}

		yield return new WaitForSeconds(currentTime);


		if (interactibleName == "Right" && annonceUnlock) // BERK MAIS OSEF
		{
			UiManager.Instance.myAnnoncement.ShowAnnoncement("ALTARS UNSEALED", unlockAltarSfx);
			AudioManager.Instance.Play2DAudio(unlockAltarVoice);
			//StatManager.Instance.AddAltarEvent(altarEvent.state.UNSEALED, "");
		}

		Unlock();
	}

	public override void Unlock ()
	{
		fillImg.gameObject.SetActive(true);
		fillImg.material.SetFloat(opacityZoneAlphaShader, 1f);
		foreach (GameObject _obj in allBraseros)
			_obj.SetActive(true);

		base.Unlock();

		waypointObj.SetUnLock();

		iconUnlock.gameObject.SetActive(true);
		iconLock.gameObject.SetActive(false);
	}

	internal void StarFinalPhase ()
	{
		waypointObj.gameObject.SetActive(false);
	}


	public void OnPlayerDie ( ushort deadP, ushort killer )
	{
		if (altarUiProgressCol.playersInUIZone.ContainsKey(deadP))
		{
			if (altarUiProgressCol.playersInUIZone[deadP] != null)
			{
				altarUiProgressCol.playersInUIZone.Remove(deadP);
			}
		}

		if (playerInZone.ContainsKey(deadP))
		{
			playerInZone.Remove(deadP);
		}
		UpdateUI();
	}

	public override void UpdateUI ()
	{
		base.UpdateUI();

		if (!altarUiProgressCol.IsplayerInUIZoneContainLocalPlayer())
		{
			return;
		}

		if (state != State.Capturable)
		{
			UiManager.Instance.SetAltarCaptureUIState(false);
			return;
		}

		if (GetLocalPlayerCountInZone() <= 0)
		{
			UiManager.Instance.SetAltarCaptureUIState(false);
			return;
		}

		if (IsLocallyContested())
		{
			UiManager.Instance.SetAltarCaptureUIState(true, true);

			var _emission = particleCapturingAlly.emission;
			_emission.rateOverTime = 0;

			var _emission1 = particleCapturingEnemy.emission;
			_emission1.rateOverTime = 0;

		}
		else
		{
			centerMesh.material.SetColor("_CapturingTeamColor", GameFactory.GetColorTeam(playerInZone.ElementAt(0).Value.teamIndex));

			if (playerInZone.ElementAt(0).Value.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
			{
				UiManager.Instance.SetAltarCaptureUIState(true, false, GetLocalPlayerCountInZone());

				var _emission = particleCapturingAlly.emission;
				_emission.rateOverTime = playerInZone.Count * 5;

				var _emission1 = particleCapturingEnemy.emission;
				_emission1.rateOverTime = 0;
			}
			else
			{
				UiManager.Instance.SetAltarCaptureUIState(false);

				var _emission = particleCapturingAlly.emission;
				_emission.rateOverTime = 0;

				var _emission1 = particleCapturingEnemy.emission;
				_emission1.rateOverTime = playerInZone.Count * 5;
			}
		}
	}
}
