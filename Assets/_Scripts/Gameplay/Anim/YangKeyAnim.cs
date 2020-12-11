using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YangKeyAnim : MonoBehaviour
{
    [SerializeField] AudioClip surchargeYangSfx;
    [SerializeField] ParticleSystem[] dashParticle;
    public void OnSurchargeSfx()
    {
        AudioManager.Instance.Play3DAudio(surchargeYangSfx, transform.position);
    }

    public void PlayParticleDash()
	{
        foreach(ParticleSystem _part in dashParticle)
		{
            _part.Play();
		}
	}
}
