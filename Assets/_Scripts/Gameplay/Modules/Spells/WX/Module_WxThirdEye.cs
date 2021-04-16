using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Module_WxThirdEye : SpellModule
{
	[SerializeField] GameObject thirdEyeShockWavePrefab;
	Transform shockWave;

	List<LocalPlayer> pingedPlayer = new List<LocalPlayer>();

	Sc_ThirdEye localTrad;
	bool outliningPlayers = false;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		GameManager.Instance.OnTowerTeamCaptured += OnTowerCaptured;
		GameManager.Instance.OnWardTeamSpawn += OnWardSpawn;
		localTrad = (Sc_ThirdEye)spell;

		if (!shockWave)
		{
			shockWave = Instantiate(thirdEyeShockWavePrefab, transform).transform;
			shockWave.transform.localPosition = Vector3.zero;
		}

		shockWave.transform.localPosition = Vector3.zero;
		shockWave.transform.localScale = Vector3.zero;
		shockWave.gameObject.SetActive(false);
	}

	private void OnDisable ()
	{
	//	Interrupt();
		GameManager.Instance.OnTowerTeamCaptured -= OnTowerCaptured;
		GameManager.Instance.OnWardTeamSpawn -= OnWardSpawn;
	}
	protected override void ResolveSpell ()
	{
		UpdateShockWaveStatus(En_ShockWaveStatus.Deploy);


		base.ResolveSpell();

	}
	public override void Interrupt ()
	{
		/*switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= ForceInterrupt;
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= ForceInterrupt;
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= ForceInterrupt;
				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= ForceInterrupt;
				break;
			case En_SpellInput.Ward:
				myPlayerModule.wardInput -= ForceInterrupt;
				break;
		}*/
		myPlayerModule.firstSpellInput -= ForceInterrupt;
		myPlayerModule.secondSpellInput -= ForceInterrupt;
		myPlayerModule.thirdSpellInput -= ForceInterrupt;
		myPlayerModule.leftClickInput -= ForceInterrupt;
		myPlayerModule.soulSpellInput -= ForceInterrupt;


		UpdateShockWaveStatus(En_ShockWaveStatus.Closing);
        myPlayerModule.RemoveState(En_CharacterState.ThirdEye);

		StopOutlineOnPlayers();

		base.Interrupt();
	}

	/*protected override void FixedUpdate ()
	{
		base.FixedUpdate();
		if (throwbackTime >= localTrad.durationOfTheOutline && outliningPlayers)
		{
			StopOutlineOnPlayers();
		}
	}*/

	void ForceInterrupt ( Vector3 _temp )
	{
		Interrupt();
	}

	void OnTowerCaptured ( VisionTower _tower )
	{
		if (isUsed)
		{
			_tower.vision.gameObject.SetActive(false);
		}
	}

	void OnWardSpawn ( Ward _ward )
	{
		if (isUsed)
		{
			_ward.GetFow().gameObject.SetActive(false);
		}
	}

	void UpdateShockWaveStatus(En_ShockWaveStatus _status)
	{
		switch(_status)
		{
			case En_ShockWaveStatus.Deploy:
				shockWave.gameObject.SetActive(true);
                CameraManager.Instance.SetNewCameraShake(0.05f, 0.05f);

                HideAllAlliedVision(false);
				//network FX
				GameObject openingFx = NetworkObjectsManager.Instance.NetworkInstantiate(1000, transform.position, Vector3.zero);
				openingFx.SetActive(false);

				Vector3 finalSize = new Vector3(spell.range, spell.range, spell.range);
				shockWave.transform.DOScale(finalSize, localTrad.anonciationTime).OnComplete(() => UpdateShockWaveStatus(En_ShockWaveStatus.Opened));

                myPlayerModule.AddState(En_CharacterState.ThirdEye);
                break;

			case En_ShockWaveStatus.Opened:

				/*switch (actionLinked)
				{
					case En_SpellInput.FirstSpell:
						myPlayerModule.firstSpellInput += ForceInterrupt;
						break;
					case En_SpellInput.SecondSpell:
						myPlayerModule.secondSpellInput += ForceInterrupt;
						break;
					case En_SpellInput.ThirdSpell:
						myPlayerModule.thirdSpellInput += ForceInterrupt;
						break;
					case En_SpellInput.Click:
						myPlayerModule.leftClickInput += ForceInterrupt;
						break;
					case En_SpellInput.Ward:
						myPlayerModule.wardInput += ForceInterrupt;
						break;
				}*/
				myPlayerModule.firstSpellInput += ForceInterrupt;
				myPlayerModule.secondSpellInput += ForceInterrupt;
				myPlayerModule.thirdSpellInput += ForceInterrupt;
				myPlayerModule.leftClickInput += ForceInterrupt;
				myPlayerModule.soulSpellInput += ForceInterrupt;
				OutlineAllPlayersInRange();
				break;

			case En_ShockWaveStatus.Closing:
				shockWave.gameObject.SetActive(true);
				shockWave.transform.DOScale(Vector3.zero, localTrad.anonciationTime).OnComplete(()=> UpdateShockWaveStatus(En_ShockWaveStatus.Hidden));
				break;

			case En_ShockWaveStatus.Hidden:
				shockWave.gameObject.SetActive(false);
                CameraManager.Instance.SetNewCameraShake(0.05f, 0.05f);

                HideAllAlliedVision(true);

            //	StopOutlineOnPlayers();
                foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
				{
					if (player.Value == GameFactory.GetLocalPlayerObj()) { continue; }

					player.Value.myPlayerModule.cursedByShili = false;
				}
				//   AudioManager.Instance.Play3DAudio(localTrad.waveAudio, transform.position);

				//network FX
				GameObject closingFx = NetworkObjectsManager.Instance.NetworkInstantiate(1001, transform.position, Vector3.zero);
				closingFx.SetActive(false);

                break;
		}
	}

	private void Update ()
	{
		if (!isUsed)
			return;
		else
			TryToPingPlayer();
	}

	void TryToPingPlayer()
	{
		if (resolved)
		{
			foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
			{
				if (player.Value == GameFactory.GetLocalPlayerObj()) { continue; }

				player.Value.myPlayerModule.cursedByShili = (Vector3.Distance(transform.position, player.Value.transform.position) <= shockWave.transform.localScale.x);
			}
		}
		else
		{
			foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
			{
				if (player.Value == GameFactory.GetLocalPlayerObj()) { continue; }

				player.Value.myPlayerModule.cursedByShili = false;
			}
		}
	}

	void OutlineAllPlayersInRange ()
	{
		pingedPlayer.Clear();

		outliningPlayers = true;

		foreach (LocalPlayer player in GameFactory.GetPlayerInRange(spell.range, transform.position))
		{
			player.forceOutline = true;
			pingedPlayer.Add(player);
		}
	}

	void StopOutlineOnPlayers()
	{
		foreach (LocalPlayer player in pingedPlayer)
		{
			player.forceOutline = false;
			outliningPlayers = false;
		}
	}
	//DEVRAIT ETRE UNE FONCTION DU GAMEMANAGER
	void HideAllAlliedVision ( bool _ShowGlobalVision )
	{
		//ward
		foreach (Ward ward in GameManager.Instance.allWard)
		{
			if (ward == null) { continue; }

			if (_ShowGlobalVision)
			{
				bool fogValue = false;
				if (GameFactory.PlayerWardAreOnSameBrume(myPlayerModule, ward))
				{
					fogValue = true;
				}
				else
				{
					if (myPlayerModule.isInBrume)
					{
						fogValue = false;
					}
					else
					{
						fogValue = true;
					}
				}
				ward.GetFow().gameObject.SetActive(fogValue);
			}
			else
			{
				ward.GetFow().gameObject.SetActive(false);
			}
		}
		//tower
		foreach (VisionTower tower in GameManager.Instance.allTower)
		{
			if (tower == null) { continue; }

			if (_ShowGlobalVision)
			{
				if (myPlayerModule.isInBrume)
				{
					tower.vision.gameObject.SetActive(false);
				}
				else
				{
					tower.vision.gameObject.SetActive(true);
				}
			}
			else
			{
				tower.vision.gameObject.SetActive(false);
			}
		}

		foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
		{
			if (player.Value == myPlayerModule.mylocalPlayer)
				continue;
		}
	}

	public enum En_ShockWaveStatus
	{
		Deploy,
		Opened,
		Closing,
		Hidden
	}
}
