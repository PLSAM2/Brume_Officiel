using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellFeedback : MonoBehaviour
{

	public PlayerModule myPlayerModule;
	float shakingTime = .15f, heardDistance = 7;

	public void PlaySound(AudioClip _audioToPlay)
	{
		AudioManager.Instance.Play3DAudio(_audioToPlay, transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true);
	}

	public void SetShakingTime(float _setShakingTime)
	{
		shakingTime = _setShakingTime;
	}
	public void SetHeardDistance ( float _setHeardDistance )
	{
		heardDistance = _setHeardDistance;
	}
	public void ShakeScreen(float _shakingStrength )
	{
		Transform player = GameFactory.GetActualPlayerFollow().transform;

		if (player != null && Vector3.Distance(player.position, transform.position) < heardDistance)
		{
			CameraManager.Instance.SetNewCameraShake(shakingTime, _shakingStrength);
		}

	}

}


