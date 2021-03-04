using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellFeedback : MonoBehaviour
{

	public PlayerModule myPlayerModule;

    public void PlaySound(AudioClip _audioToPlay)
	{
		AudioManager.Instance.Play3DAudio(_audioToPlay, transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true);
	}


}
