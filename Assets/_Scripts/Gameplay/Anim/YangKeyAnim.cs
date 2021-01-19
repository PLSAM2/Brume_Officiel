using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YangKeyAnim : MonoBehaviour
{
    [SerializeField] AudioClip surchargeYangSfx;
    [SerializeField] ParticleSystem[] dashParticle;

    [SerializeField] LocalPlayer myLocalplayer;

    public void OnSurchargeSfx()
    {
        AudioManager.Instance.Play3DAudio(surchargeYangSfx, transform.position, myLocalplayer.myPlayerId, true);
    }

    public void PlayParticleDash()
	{
        foreach(ParticleSystem _part in dashParticle)
		{
            _part.Play();
		}
	}
}
